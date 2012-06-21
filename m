Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2FUKaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:30:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25323 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2FUKaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:30:18 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-6a-4fe2f7aa6297
From: Jingoo Han <jg1.han@samsung.com>
To: wfg@linux.intel.com, "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Kim, Milo'" <Milo.Kim@ti.com>,
        "'Axel Lin'" <axel.lin@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20120621101721.GA12365@localhost>
In-reply-to: <20120621101721.GA12365@localhost>
Subject: RE: akpm 117/143] ERROR: "devm_gpio_request_one"
 [drivers/video/backlight/l4f00242t03.ko] undefined!
Date: Thu, 21 Jun 2012 19:30:02 +0900
Message-id: <000e01cd4f98$d1366a40$73a33ec0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1PlxG/rDk6gR3BTXG69bRdv+2M5wAARqug
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd1V3x/5Gzx7bWlxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyrq1exF7Qx1nR2PiUvYFxM3sXIyeHhICJxLGrE1khbDGJC/fW
	s3UxcnEICSxilFi2/A0zhDObSWLm5xcsIFVsAmoSX74cBusWEciW+PltEVgHs8B2Rolr846A
	jRIS0JNoWbqdDcTmFNCX+LrlIFhcWCBf4v+UC2BxFgFViZ3TXwEN5eDgFbCV+DG5ECTMKyAI
	ZN4D28UsoCWxfudxJghbXmLzmrfMIOUSAuoSj/7qQpxgJHHw732ochGJfS/eMU5gFJqFZNIs
	JJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBgfxMagfjygaLQ4wCHIxK
	PLw/Pj3yF2JNLCuuzD3EKMHBrCTCe+oRUIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB
	9MSS1OzU1ILUIpgsEwenVAPjToPba0NnfNbyPJAttPReU72dUtpBZYvJ11dcr09yP7/h5YRY
	6wPbnz94vrrjruz7azpSXOclE481LqkWquL8ds7PZ6tXyX7bHRLyd4/WmMf5n3izwIl7N7/g
	UweDwF2b06bq/O83in1twrl8T/CduYW+q05n/Vj4e77apIhZTNtLOqK7U5VllFiKMxINtZiL
	ihMBToG0kmACAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012 7:17 PM Fengguang Wu wrote:

> 
> Hi all,
> 
> Yet another error on devm_gpio_request_one()... Interestingly the
> patch title says "export" but does not really export the symbol...
> 
> Thanks,
> Fengguang
> ---
> Kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> head:   3ff60ad39879eca9c1016d6e29b007ddc8f6c922
> commit: 779e06e1ecb540bcd1b1b8ea66f9fd96febbc898 [117/143] backlight: l4f00242t03: export and use
> devm_gpio_request_one()
> config: i386-allmodconfig (attached as .config)
> 
> All related error/warning messages:
> 
> ERROR: "devm_gpio_request_one" [drivers/video/backlight/l4f00242t03.ko] undefined!

Hi Fengguang,

The patch a291ede7be8359a8986740b11b93f9c80e40210b ' backlight-l4f00242t03-use-devm_gpio_request_one-fix'
is necessary to fix the export problem.

In my opinion, Andrew Morton will fold these patches as usual.
Thank you.

Best regards,
Jingoo Han

> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

