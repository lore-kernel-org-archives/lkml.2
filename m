Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2LEBSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:18:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16934 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2LEBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:18:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ef-50bea0c67376
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Marko Katic'" <dromede@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01cdd1e0$293f0d90$7bbd28b0$%han@samsung.com>
 <20121204145822.056b6cf6.akpm@linux-foundation.org>
In-reply-to: <20121204145822.056b6cf6.akpm@linux-foundation.org>
Subject: Re: [PATCH v3] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
Date: Wed, 05 Dec 2012 10:17:58 +0900
Message-id: <000501cdd286$5c8f7ad0$15ae7070$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Sct45V/efF0XVS+2Us2zYzFBhQwAEfeOA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA91jC/YFGKz6YWBxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyPvapFEznqWjo/8jcwHiTs4uRk0NCwERi8Z7VzBC2mMSFe+vZ
	uhi5OIQEljFK/PyygqWLkQOsaMWZGoj4IkaJ/ycOMkI4s5kkruyZywrSzSagJvHly2F2kAYR
	AX2JthYNkBpmgRVMEkd7HoDFhQSKJSYeDgAp5xRwkLjd0cwOYgsLxEn8n9vHBGKzCKhK7G1Y
	CjaSV8BW4sLuXVC2oMSPyfdYQGxmAS2JzduaWCFseYnNa94yQ9ypLvHory5IWETASGLmjGao
	chGJfS/eMUKMF5D4NvkQ1FuyEpsOMINcKSGwiF3i7ow+Fkg4SEocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRESVdI7GFc1WBxiFOBgVOLhlTDe
	FyDEmlhWXJl7iFGCg1lJhPefHVCINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84ERn1cSb2hs
	bGJmYmpibmlqbopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDo3x+RGhjrM6vznT9HI2b
	90xLGbc+id7zOOndwpnsEzPEYmTsXDUm/e18E/Tn3szkj3GSuS+iMo/HqW6+s4Fb6rzq2de/
	V7FEJuybvlgz3Ljy76R0wX9TQ2NrbjlpHTKcl2v7R0yl4kv/7TUsj6PvdCxwfvZ5k6lUSOQL
	35exmzlX7p8tdGXDGiWW4oxEQy3mouJEAPoZsArXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd1jC/YFGGw4pWNxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMz72qRRM56lo6P/I3MB4
	k7OLkYNDQsBEYsWZmi5GTiBTTOLCvfVsXYxcHEICixgl/p84yAjhzGaSuLJnLitIFZuAmsSX
	L4fZQZpFBPQl2lo0QGqYBVYwSRzteQAWFxIolph4OACknFPAQeJ2RzM7iC0sECfxf24fE4jN
	IqAqsbdhKdhIXgFbiQu7d0HZghI/Jt9jAbGZBbQkNm9rYoWw5SU2r3nLDHGzusSjv7ogYREB
	I4mZM5qhykUk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEx+wz6R2MqxosDjEKcDAq8fBKGO8LEGJNLCuuzD3EKMHBrCTC+88OKMSbklhZlVqU
	H19UmpNafIjRB+jRicxSosn5wHSSVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1
	tSC1CGYcEwenVAPjhOR5NsYVe/UWf3Y4dTn3/f/tzmsDGJQN+hJj9L69+jZ/dvrUmzuETX7k
	K1VbhB+47HzAyHpL7CPdVs+nUttdl7UL90Rd9eSfsLrX4HOzbX+8wX2LVRLzUy6fCLmerrTw
	5D71H0wBNUHX991I7+f9InFMov9t+H6GM12eGyQP5+3JO/MqbHOcEktxRqKhFnNRcSIAJLV2
	DgYDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 05, 2012 7:58 AM, Andrew Morton wrote
> On Tue, 04 Dec 2012 14:28:15 +0900
> Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > From: Marko Katic <dromede@gmail.com>
> >
> > Changing backlight intensity on an Akita (Sharp Zaurus C-1000)
> > triggers WARN_ON message:
> 
> Well, I queued it up.
> 
> > ...
> >
> > --- a/drivers/video/backlight/corgi_lcd.c
> > +++ b/drivers/video/backlight/corgi_lcd.c
> > @@ -408,11 +408,20 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
> >  	/* Bit 5 via GPIO_BACKLIGHT_CONT */
> >  	cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
> >
> > -	if (gpio_is_valid(lcd->gpio_backlight_cont))
> > -		gpio_set_value(lcd->gpio_backlight_cont, cont);
> > +	if (gpio_is_valid(lcd->gpio_backlight_cont)) {
> > +		if (gpio_cansleep(lcd->gpio_backlight_cont))
> > +			gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
> > +		else
> > +			gpio_set_value(lcd->gpio_backlight_cont, cont);
> > +	}
> 
> But this looks utterly daft.  Grant, these two things are the same - do
> we need both of them?

Hi Andrew,

There is another difference, except for warning message.
There is might_sleep_if(extra_checks) in gpio_set_value_cansleep().

Also, I saw the Documentation/gpio.txt as below:

172         /* GPIO OUTPUT */
173         void gpio_set_value(unsigned gpio, int value);
...
213         /* GPIO OUTPUT, might sleep */
214         void gpio_set_value_cansleep(unsigned gpio, int value);


Best regards,
Jingoo Han


