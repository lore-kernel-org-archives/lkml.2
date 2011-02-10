Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1BJH06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:26:58 -0500
Received: from mswedge2.sunplus.com ([124.219.29.227]:56255 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1BJH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:26:57 -0500
In-Reply-To: <20110206222246.281228273@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] score: Select GENERIC_HARDIRQS_NO_DEPRECATED
MIME-Version: 1.0
X-KeepSent: 6CAF901B:FBFD5FE8-48257833:0025EC26;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF6CAF901B.FBFD5FE8-ON48257833.0025EC26-48257833.00260476@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Thu, 10 Feb 2011 14:55:15 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 8.5.1|September 28, 2009) at 2011/02/10 ?? 02:55:15,
	Serialize complete at 2011/02/10 ?? 02:55:15
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1A7R8ii024533

Thomas Gleixner <tglx@linutronix.de> Ğ´ÓÚ 2011-02-07 06:23:50:

> All chips converted and proper accessor functions used.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/score/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-next/arch/score/Kconfig
> ===================================================================
> --- linux-next.orig/arch/score/Kconfig
> +++ linux-next/arch/score/Kconfig
> @@ -3,6 +3,7 @@ menu "Machine selection"
>  config SCORE
>         def_bool y
>         select HAVE_GENERIC_HARDIRQS
> +       select GENERIC_HARDIRQS_NO_DEPRECATED
> 
>  choice
>     prompt "System type"
> 
> 

Acked-by: Chen Liqin <liqin.chen@sunplusct.com>
--

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
