Cef Builds
==========

Тут собраны патчи для [CEF](https://bitbucket.org/chromiumembedded/cef) (и их сборки), необходимые для работы [Brick](https://github.com/buglloc/brick).

В [distrib](https://github.com/buglloc/cef-builds/tree/master/distrib) можно найти полные сборки CEF собранные со всеми нужными патчами.
А в [libs](https://github.com/buglloc/cef-builds/tree/master/libs) только `CEF_BINARY_FILES` необходимые для работы Brick.

### extend_cef_response.patch

Добавляет возможность получить effective url в [CefResponse](http://magpcss.org/ceforum/apidocs/projects/%28default%29/CefResponse.html). Это единственный (известный мне) способ получить реальную урлу в следствии редиректов или HSTS для запросов сделанных при помощи [CefURLRequestClient](http://magpcss.org/ceforum/apidocs/projects/%28default%29/CefURLRequestClient.html).


### stop_on_redirect.patch

Добавляет новый флаг `UR_FLAG_STOP_ON_REDIRECT` для [CefURLRequest](http://magpcss.org/ceforum/apidocs/projects/%28default%29/CefURLRequest.html). Он прокидывается хромовскому UrlFetcher'у и тот в свою очередь отменит запрос при редиректе, а не последует за ним.


### extend_internal_window_events.patch

К сожалению, CEF имеет ряд проблем в связке с родительским GTK окошком, например, [Linux: 2171: cefclient: Focus-related events are not correct](https://bitbucket.org/chromiumembedded/cef/issue/1493/linux-2171-cefclient-focus-related-events). Таким образом Brick не осталось ничего другого как избавится от родительского (по отношению к CEF) окна, что породило несколько проблем:
 - Нужно иметь возможность настраивать окно до того как оно будет замапленно
 - Нужно адекватно реагировать на закрытие окна

Разумеется, правильнее всего было бы пойти и исправить работу самого окна, а не костылять вокруг. Но сейчас это не важно, до тех пор пока Brick не захочет заиметь реалтаймовую многоаккаунтность.
Этот патч решает обе проблемы, добавляя два новых события:

`bool OnCloseBrowser(CefRefPtr<CefBrowser> browser)`

Фаерится при DeleteEvent, при этом вызывается как можно выше (до "deal with onbeforeunload"), для того что бы со стороны JS не было никаких следов.

`void OnWindowCreated(CefRefPtr<CefBrowser> browser)`

Фаерится _после_ создания окна, но _до_ его маппинга в иксы.

