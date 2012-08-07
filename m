Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2HGKGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:06:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28070 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2HGKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:06:39 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-a8-5020e8ad52ea
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Alessandro Rubini'" <rubini@gnudd.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
 <20120701104401.GA4352@mail.gnudd.com> <20120703130042.GA10007@mail.gnudd.com>
 <201207031319.40884.arnd@arndb.de>
 <20120703193403.GA26355@n2100.arm.linux.org.uk>
 <CACRpkdZLGhgpUJy_3QGYvGRqyxMkkPPSdyP==h5YurWqKnctBw@mail.gmail.com>
In-reply-to: <CACRpkdZLGhgpUJy_3QGYvGRqyxMkkPPSdyP==h5YurWqKnctBw@mail.gmail.com>
Subject: RE: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Date: Tue, 07 Aug 2012 19:06:37 +0900
Message-id: <098e01cd7484$553871c0$ffa95540$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zSOYqbJKc8cPmS5izEn7oeMXzOgBLN/6A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jQd11LxQCDPbMYrLo2PWVxeLyrjls
	FmcW97I7MHt83iQXwBjFZZOSmpNZllqkb5fAlbHwrnjBBraKL0cvsTYwNrF2MXJwSAiYSLy4
	U9/FyAlkiklcuLeerYuRi0NIYDqjxNF1N1khnL+MEnee97OCVLEJaEgcfv+MHSQhItDHKHG6
	dysjSIJZYA+TxL9XBhAdm5kk5refZgNJcAoESzw72cQCYgsLeEp09dwEa2ARUJU4u7CHGeQM
	XgFbifnL00HCvAKCEj8m32OBmKklsX7ncSYIW15i85q3zBBXq0s8+qsLYooIGEn8WccJUSEi
	se/FO8YJjEKzkAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLCf
	Se9gXNVgcYhRgINRiYd3popCgBBrYllxZe4hRgkOZiUR3sM7gUK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5Tby/+gsJpCeWpGanphakFsFkmTg4pRoYZ29JYSxamJ8WmmmRU3LmafC+rfaNF4rd
	6j+fESrU6eLZJbHnwqz/zsavTqQouB3u7z14+ljSiWW5WnlTrzBs/9N8bc/t2283zNtsv4Bl
	GcNTx3op0fmcVn6HX19nLf3vOVPNIWxK2++J1VPm8b2daNXFsaJf8KDJ2v3hboLWcxhetPtE
	dv61VWIpzkg01GIuKk4EAPfEXWloAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 

[...]

> The major reason why that file is there is that there is *another*
> PL080 driver in arch/arm/mach-s3c64xx/dma.c which I repeatedly
> asked the Samsung people to replace with the
> drivers/dma/amba-pl08x.c driver. :-(
> 
> When I worked on the PL08x driver in drivers/dma I reused
> this header to avoid code duplication.
> 
> Now that thing is stranding in the way. Alim, Kukjin, what's happening?
> 
Afaik, Alim was working on that but I'm not sure how long he needs more?

Alim, please share the progress of the pl080 work?

> I feel tempted to update Alim's patch myself and push it on you
> soon...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

