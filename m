Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2KTCRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:17:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2KTCRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:17:19 -0500
X-AuditID: cbfee60f-b7f5a6d000001e30-bc-50aae820e97f
Date: Tue, 20 Nov 2012 02:17:04 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 445/493] backlight: remove use of __devexit
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121120021333640@jg1.han
Msgkey: 20121120021333640@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121120021333640@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <23661060.680501353377820639.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zI12FF6sCDOZuY7G4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqYsX52C0vBK5GKy8vdGxgXiHQxcnIICShJTDq5lxHElhAwkdh36zk7
	hC0mceHeerYuRi6gmmWMEv8P7mCBKbox7QIrRGI+o8T2BYuAHA4OFgFViYNrwIayCahLTPjd
	DFYvLGAv0f9nAdgCEQFNif3n77KA9DILtDBL7Lq5iR3iClmJe5NnM4PYvAKCEidnPoFapiCx
	v+sHO0RcUaJ75hmo6yQk7tzfzwph80rMaH8KVS8nMe3rGmYIW1ri/KwNjDDfLP7+GCrOL3Hs
	9g4mkJtBep/cD4YZs3vzFzYIW0Bi6pmDUK2qEhN7PzFB2HwSaxa+hVolKHH6WjczTG/Dxt9g
	pzEDnTml+yGUrSXx5cc+NnRv8Qo4Scxv/8w8gVF5FpLULCTts5C0I6tZwMiyilE0tSC5oDgp
	PdUUObI3MULSIP8OxkUNFocYBTgYlXh4LZNXBQixJpYVV+YeYpTgYFYS4W0qBwrxpiRWVqUW
	5ccXleakFh9inMgIjMGJzFKiyfnAJJ1XEm9obGxiZmJqYm5pam5KjLC5kakBMAEbGJIorCTO
	y14xPUBIID2xJDU7NbUgtQjmKCYOTqkGxtAF3I9eL5siIZV6sftIxlXZtYprcv9XOfM8aAky
	Yas/9pT1AM+FWykd9xdEyrtsnb8q0S/bK/10dtB8XpZOzc/fH3E9Y7Ro2yWba+5Ua35Xm/Ni
	x7u9Cs81qpw/L46Z5SVltO/LD5u4nS9OZhyKnPxYrf0h742IID8xnfWzf1s/WhQ2tXJfhBJL
	cUaioRZzUXEiAEF9ZVD2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/tmboKL1YFGGzxtri8aw6bA6PH501y
	AYxRGTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDOV
	FMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZK0UYGxnpGpiZ6RsYGesaWsVaGBgZGpkBVCRkZ
	62e3sBS8Eqm4vNy9gXGBSBcjJ4eQgJLEpJN7GUFsCQETiRvTLrBC2GISF+6tZ+ti5AKqmc8o
	sX3BIqAEBweLgKrEwTVgvWwC6hITfjezgNjCAvYS/X8WgM0REdCU2H/+LgtIL7NAC7PErpub
	2CGWyUrcmzybGcTmFRCUODnzCQvEMgWJ/V0/2CHiihLdM8+wQ8QlJO7c3w91EK/EjPanUPVy
	EtO+rmGGsKUlzs/awAhz9OLvj6Hi/BLHbu9gArkZpPfJ/WCYMbs3f2GDsAUkpp45CNWqKjGx
	9xMThM0nsWbhW6hVghKnr3Uzw/Q2bPwNdhoz0JlTuh9C2VoSX37sY0P3Fq+Ak8T89s/MExjl
	ZiFJzULSPgtJO7KaBYwsqxhFUwuSC4qT0lNN9YoTc4tL89L1kvNzNzGC09Mz/h2MixosDjEK
	cDAq8fBaJq8KEGJNLCuuzD3EKMHBrCTC21QOFOJNSaysSi3Kjy8qzUktPsToA4zAicxSosn5
	wNSZVxJvaGxsYmZiam5gYWBpjkNYSZyXvWJ6gJBAemJJanZqakFqEcw4Jg5OqQbG6pevbB4Y
	Mqf1WW/YXdF1OLavtm11+2y2Y2tZZ7KtONop5/z/1KTdeyeXh93ZEjNj0efsBqYPquHWN8TX
	XWC/2mH9y3DRygM1FaeFNipNb8l/9nOKjca2BZNvLLUy5eiJsdnnn3yAXXtq9iyGmLlPfLmn
	TxIOffnYYscxoRSe7Y6RG33M5nhnKbEUZyQaajEXFScCAHClhiN8AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK2HOu2019018

On Tuesday, November 20, 2012 3:27 AM, Bill Pemberton wrote
> 
> CONFIG_HOTPLUG is going away as an option so __devexit is no
> longer needed.
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/adp5520_bl.c         | 2 +-
>  drivers/video/backlight/adp8860_bl.c         | 6 +++---
>  drivers/video/backlight/adp8870_bl.c         | 6 +++---
>  drivers/video/backlight/ams369fg06.c         | 2 +-
>  drivers/video/backlight/apple_bl.c           | 2 +-
>  drivers/video/backlight/corgi_lcd.c          | 2 +-
>  drivers/video/backlight/ep93xx_bl.c          | 2 +-
>  drivers/video/backlight/hp680_bl.c           | 2 +-
>  drivers/video/backlight/ili9320.c            | 2 +-
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
>  25 files changed, 29 insertions(+), 29 deletions(-)
> 

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
