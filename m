Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193Ab2FDXLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:11:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17548 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175Ab2FDXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:11:13 -0400
X-AuditID: cbfee61b-b7f0b6d000000f04-13-4fcd408e20bf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@stericsson.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: <000101cd41f8$251e4cd0$6f5ae670$%han@samsung.com>
 <CACRpkdaM2VbieCY5deDDHCXEH+gHXJndpYVbXENSbWU4t-_YsA@mail.gmail.com>
In-reply-to: <CACRpkdaM2VbieCY5deDDHCXEH+gHXJndpYVbXENSbWU4t-_YsA@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: fix build error for EXYNOS5250
Date: Tue, 05 Jun 2012 08:11:10 +0900
Message-id: <000101cd42a7$542bf130$fc83d390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1CdO38u1UBEN7xSoabQjPxfnqxYQAMTfuA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jQd0+h7P+Bv0HlS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGruUnWAvOcVTM+faGsYGxh72LkZNDQsBE4sjPT4wQtpjEhXvr
	2boYuTiEBKYzSjyedo4FwpnNJHG6/QYbSBWbgJrEly+HwbpFBPQk3nxtYQcpYha4zyhxf2sX
	E0RHC6NEy7V+VpAqToFgiW+P14HtEBZwkphw7hkziM0ioCrx8NkvFhCbV8BWYt6eH1C2oMSP
	yffAbGYBLYn1O48zQdjyEpvXvAXq5QC6VV3i0V9diCOMJGZ8us0OUSIise/FO8YJjEKzkEya
	hWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJifSe9gXNVgcYhRgINR
	iYf3wIkz/kKsiWXFlbmHGCU4mJVEeJ9MBArxpiRWVqUW5ccXleakFh9ilOZgURLnfbJkh7+Q
	QHpiSWp2ampBahFMlomDU6qBUe367r2+FycKZfT6tFQlWX9d8+LmiYu1b8weuVzaGTlRUWZ7
	lUqP0OS/W4+s2l0foT7lv4Z2SPHk57N93Yx6n86z7q68GZKuJbHbg/W0is/Dd+8Pz/eoYOw/
	M2vp0eVv9ibo2UlcfDFpm4fHNKadwoeuBOjacbqYffl1eKHPlvwLz9McguS5fyixFGckGmox
	FxUnAgDBfEJbYgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Jun 5, 2012 at 2:10 AM, Linus Walleij < linus.walleij@linaro.org> wrote:

> 
> On Mon, Jun 4, 2012 at 4:17 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Fixed a typo from "exonys5_gpios_1" to "exonys5_gpios_1"
> > in order to fix build error as below:
> >
> > drivers/gpio/gpio-samsung.c: In function 'exynos5_gpiolib_init':
> > drivers/gpio/gpio-samsung.c:2836: error: 'exonys5_gpios_1' undeclared (first use in this function)
> > drivers/gpio/gpio-samsung.c:2836: error: (Each undeclared identifier is reported only once
> > drivers/gpio/gpio-samsung.c:2836: error: for each function it appears in.)
> >
> > Cc: Thomas Abraham <thomas.abraham@linaro.org>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Hi Linus Walleij,

This patch is superfluous, for another patch is merged to linux 'master' branch by Linus Torvalds as below.
commit 5041caa "gpio/samsung: fix the typo 'exynos5_xxx' instead of 'exonys5_xxx'" by Kukjin Kim.
Thank you.

Best regards,
Jingoo Han

> 
> Yours,
> Linus Walleij

