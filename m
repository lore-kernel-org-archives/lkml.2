Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2DUKvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:51:24 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:42445 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DUKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:51:23 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4?= 
	<linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCAxMi8xN10gQVJNIGNscHM3MTF4OiBTaW1wbGUgb3B0?=
 =?UTF-8?B?aW1pc2UgZGVidWdfbWFjcm8gYnkgcmVtb3Zpbmcgb25lIE5PUA==?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [188.134.41.72]
Date: Sat, 21 Apr 2012 14:50:54 +0400
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-13-git-send-email-shc_work@mail.ru> <20120421104627.GD24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120421104627.GD24211@n2100.arm.linux.org.uk>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 
Content-Type: text/plain; charset=utf-8
Message-Id: <E1SLXu2-0004zV-VD.shc_work-mail-ru@f280.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3LAprvj010014

Sat, 21 Apr 2012 11:46:27 +0100 Ğ¾Ñ‚ Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sat, Apr 21, 2012 at 01:11:25PM +0400, Alexander Shiyan wrote:
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  arch/arm/mach-clps711x/include/mach/debug-macro.S |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/mach-clps711x/include/mach/debug-macro.S b/arch/arm/mach-clps711x/include/mach/debug-macro.S
> > index 118b3d9..37c4d8a 100644
> > --- a/arch/arm/mach-clps711x/include/mach/debug-macro.S
> > +++ b/arch/arm/mach-clps711x/include/mach/debug-macro.S
> > @@ -14,10 +14,8 @@
> >  #include <mach/hardware.h>
> >  
> >  		.macro	addruart, rp, rv, tmp
> > -#ifndef CONFIG_DEBUG_CLPS711X_UART2
> > -		mov	\rp, #0x0000	@ UART1
> > -#else
> > -		mov	\rp, #0x1000	@ UART2
> > +#ifdef CONFIG_DEBUG_CLPS711X_UART2
> > +		mov	\rp, #0x1000	@ Add offset for UART2 base reg
> >  #endif
> 
> This looks wrong.  How is rp initialized if CONFIG_DEBUG_CLPS711X_UART2 is
> not set?
You are right. My mistake.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
