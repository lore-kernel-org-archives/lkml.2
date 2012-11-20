Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2KTCTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:19:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14937 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2KTCTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:19:30 -0500
X-AuditID: cbfee60f-b7f5a6d000001e30-27-50aae8b0ff65
Date: Tue, 20 Nov 2012 02:19:28 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 120/493] backlight: remove use of __devexit_p
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121120021738201@jg1.han
Msgkey: 20121120021738201@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121120021738201@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25871870.680711353377965732.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zQ90NL1YFGHw4Zm1xedccNgdGj8+b
	5AIYoxoYbRKLkjMyy1IVUvOS81My89JtlUJD3HQtlBQy8otLbJWijQyM9YxMTfSMTMz1LA1i
	rYxMlRTyEnNTbZUqdKF6lRSKkguAanMri4EG5KTqQcX1ilPzUhyy8ktBLtErTswtLs1L10vO
	z1VSKEvMKQUaoaSfMJUx48mDDvaCU8IV23Y9ZG5gbBHuYuTkEBJQkph0ci8jiC0hYCLRMvcx
	E4QtJnHh3no2iJpljBIPm9VhavbO/8jcxcgFFJ/PKHFq/U52kASLgKrExrXbwRrYBNQlJvxu
	ZgGxhQUcJRZuXgdWIyKgKbH//F0WkGZmgQXMEktnNzFDbJCVuDd5NpjNKyAocXLmExaIbQoS
	G/u/MEHEFSVaX/RCXSohcef+flYIm1diRvtTqHo5iWlf1zBD2NIS52dtYIT5ZvH3x1Bxfolj
	t3cAzeQA631yPxhmzO7NX9ggbAGJqWcOQrWqSvyd2wDVyiexZuFbqFWCEqevdTPD9DZs/A32
	IzPQmVO6H0LZWhJffuxjQ/cWr4CTxNk9q9gmMCrPQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCel
	p5oix/YmRkgi5N/BuKjB4hCjAAejEg+vZfKqACHWxLLiytxDjBIczEoivE3lQCHelMTKqtSi
	/Pii0pzU4kOMExmBUTiRWUo0OR+YpvNK4g2NjU3MTExNzC1NzU2JETY3MjUApmADQxKFlcR5
	2SumBwgJpCeWpGanphakFsEcxcTBKdXAeDX6gVjQxSWBJZGHFiofP+D35LFXUvy5CTm177Kn
	tU9tXnan8ary8bupXx7e5o1uSStwz1YsrG1jvCW2IG/ya/UWNj21H9W9pW5eYVdWazomF4fL
	7zutnHnrZgmT5tWwXrW43fyzZfds/H9FJWb9j9qIHqZDPWYHyi3Zdu65rxf6bJ1G/TMxJZbi
	jERDLeai4kQAvxreGPcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t/t6bobXqwKMJi+xtzi8q45bA6MHp83
	yQUwRmXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAN
	VVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKkUbGRjrGZma6BkZG+gZW8ZaGRoYGJkCVSVk
	ZDx50MFecEq4Ytuuh8wNjC3CXYycHEICShKTTu5lBLElBEwk9s7/yAxhi0lcuLeerYuRC6hm
	PqPEqfU72UESLAKqEhvXbmcDsdkE1CUm/G5mAbGFBRwlFm5eB1YjIqApsf/8XRaQZmaBBcwS
	S2c3MUNsk5W4N3k2mM0rIChxcuYTFohtChIb+78wQcQVJVpf9EJdJCFx5/5+VgibV2JG+1Oo
	ejmJaV/XQF0qLXF+1gZGmKsXf38MFeeXOHZ7B9BMDrDeJ/eDYcbs3vyFDcIWkJh65iBUq6rE
	37kNUK18EmsWvoVaJShx+lo3M0xvw8bfYD8yA505pfshlK0l8eXHPjZ0b/EKOEmc3bOKbQKj
	3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqqqV5xYm5xaV66XnJ+7iZGcJJ6xr+DcVGDxSFG
	AQ5GJR5ey+RVAUKsiWXFlbmHGCU4mJVEeJvKgUK8KYmVValF+fFFpTmpxYcYfYAxOJFZSjQ5
	H5hA80riDY2NTcxMTM0NLAwszXEIK4nzsldMDxASSE8sSc1OTS1ILYIZx8TBKdXAuGy3pfAh
	jwfvDni8US1KWvaZa7/G4r3fwhqMNsz0/jDzXUsg37nvvRs/3Zy7WzI1UOVQ0405bREeeia8
	lm/5jh2JcYisV60xMSvnW73MPkw5Q3mWypxry36dXhQzadLa/jTHnHNmE68vvf2zyu3+vhkl
	MyY63ZCeteYqh9nPDcZO0bwcxt73TiuxFGckGmoxFxUnAgAhgoGofwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK2Jasd019025

On Tuesday, November 20, 2012 3:21 AM, Bill Pemberton wrote
> 
> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/adp5520_bl.c         | 2 +-
>  drivers/video/backlight/adp8860_bl.c         | 2 +-
>  drivers/video/backlight/adp8870_bl.c         | 2 +-
>  drivers/video/backlight/ams369fg06.c         | 2 +-
>  drivers/video/backlight/corgi_lcd.c          | 2 +-
>  drivers/video/backlight/ep93xx_bl.c          | 2 +-
>  drivers/video/backlight/hp680_bl.c           | 2 +-
>  drivers/video/backlight/l4f00242t03.c        | 2 +-
>  drivers/video/backlight/ld9040.c             | 2 +-
>  drivers/video/backlight/lm3533_bl.c          | 2 +-
>  drivers/video/backlight/lm3630_bl.c          | 2 +-
>  drivers/video/backlight/lm3639_bl.c          | 2 +-
>  drivers/video/backlight/lms283gf05.c         | 2 +-
>  drivers/video/backlight/lp855x_bl.c          | 2 +-
>  drivers/video/backlight/ltv350qv.c           | 2 +-
>  drivers/video/backlight/max8925_bl.c         | 2 +-
>  drivers/video/backlight/pcf50633-backlight.c | 2 +-
>  drivers/video/backlight/platform_lcd.c       | 2 +-
>  drivers/video/backlight/s6e63m0.c            | 2 +-
>  drivers/video/backlight/tdo24m.c             | 2 +-
>  drivers/video/backlight/tosa_bl.c            | 2 +-
>  drivers/video/backlight/tosa_lcd.c           | 2 +-
>  drivers/video/backlight/vgg2432a4.c          | 2 +-
>  23 files changed, 23 insertions(+), 23 deletions(-)
> 

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
