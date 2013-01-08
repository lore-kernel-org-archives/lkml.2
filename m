Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3AHBZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:25:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43154 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3AHBZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:25:37 -0500
X-AuditID: cbfee61b-b7f616d00000319b-29-50eb758ffd71
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01cdea55$92725aa0$b7570fe0$%han@samsung.com>
 <20130107160137.dec5098a.akpm@linux-foundation.org>
In-reply-to: <20130107160137.dec5098a.akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: check null deference of name when device is
 registered
Date: Tue, 08 Jan 2013 10:25:35 +0900
Message-id: <003c01cded3f$0f25a3e0$2d70eba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3tM1ZDNAznOdAjTA2zBfNY2HYi5QACx3vA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI93+0tcBBmtW61uc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmf3rIVrCEs2LWrCOMDYxz2LsYOTgkBEwkLi0p7mLk
	BDLFJC7cW8/WxcjFISSwjFHicONidoiEicTsb/egEosYJRafWsEI4fxilFj6DaSFk4NNQE3i
	y5fDYFNFBPQl2lo0QMLMAvsZJR7vcwKxhQSKJVZs2sEIYnMKOEgcmPeFBcQWFoiQuLBnLlic
	RUBV4uflx2A2r4CtxK8JC1ghbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVtmiGfUJR791YW4wEji
	xVI/iAoRiX0v3kFNF5D4NvkQC0S1rMSmA8wgj0gILGOXmD2xnRHiXUmJgytusExglJiFZPEs
	JItnIVk8C8mKBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFC4kt6B+OqBotDjAIcjEo8
	vJdiXgcIsSaWFVfmHmKU4GBWEuG9lQIU4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5Hxg7OeV
	xBsaG5uYmZiamFuampviEFYS52U89SRASCA9sSQ1OzW1ILUIZhwTB6dUA+Oa3dkZt8InF8ic
	/NHTpqzeK5fIY/5kI3uCuM2aPz33084x796lZPJCln+Kb0DDv09516cXH1nJvq0s4bDzvD+f
	njB+EVht0l706SZLP+/hG3OZuf+eKAuMmDrxmIK8k9hDf28NSYaDvR7sz8UDjrhJ7WFht+z+
	fy3rVK5d3I0jKk2PkyefsVdiKc5INNRiLipOBABbhhEI3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd3+0tcBBkvnalmc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzpn96yFawhLNi
	1qwjjA2Mc9i7GDk5JARMJGZ/u8cGYYtJXLi3Hsjm4hASWMQosfjUCkYI5xejxNJv68Gq2ATU
	JL58OQzUzcEhIqAv0daiARJmFtjPKPF4nxOILSRQLLFi0w5GEJtTwEHiwLwvLCC2sECExIU9
	c8HiLAKqEj8vPwazeQVsJX5NWMAKYQtK/Jh8jwVippbE+p3HmSBseYnNa94yg6yVEFCXePRX
	F+ICI4kXS/0gKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEx+8z6R2MqxosDjEKcDAq8fBeinkdIMSaWFZcmXuIUYKDWUmE91YKUIg3JbGy
	KrUoP76oNCe1+BCjD9CfE5mlRJPzgaklryTe0NjEzMjSyMzCyMTcHIewkjgv46knAUIC6Ykl
	qdmpqQWpRTDjmDg4pRoY527M2ux4wkn/jteHtyzpfBYTI+VeB84uWiimffdMTkPk8fvChWlG
	goHmPiZHOc+JKQTJGGcWB+VdOeabZWVsxSP6yvrqyjsy3mXGIZu8Fq2sebtK3yTefPtjwc1/
	J569+qMsuL3gb4+a8q4Kdt2q5u+Ws0tevVy4UJfR/d91LdkvCgV1MlpKLMUZiYZazEXFiQCb
	wEKdDAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2013 9:02 AM, Andrew Morton wrote
> On Fri, 04 Jan 2013 17:29:11 +0900
> Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > NULL deference of name is checked when device is registered.
> > If the name is null, it will cause a kernel oops in dev_set_name().
> >
> > ...
> >
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -292,6 +292,11 @@ struct backlight_device *backlight_device_register(const char *name,
> >  	struct backlight_device *new_bd;
> >  	int rc;
> >
> > +	if (name == NULL) {
> > +		pr_err("backlight name is null\n");
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> >  	pr_debug("backlight_device_register: name=%s\n", name);
> 
> I don't understand this.
> 
> Is there some driver which is calling these functions with name=NULL?
> If so, which one(s)?

No, there is no one.

> 
> If "no" then why don't we declare that "passing name=NULL is a bug" and
> leave the code as-is?

Do you mean following?

+	if (name == NULL)
+		pr_err("passing name=NULL is a bug");
+
  	pr_debug("backlight_device_register: name=%s\n", name);


Best regards,
Jingoo Han



