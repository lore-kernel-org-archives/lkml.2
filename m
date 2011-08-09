Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1HIIcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:32:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14140 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1HIIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:32:47 -0400
X-AuditID: cbfee610-b7ce5ae00000749c-7b-4e40f0ad5788
Date: Tue, 09 Aug 2011 08:32:45 +0000 (GMT)
From: JinGoo Han <jg1.han@samsung.com>
Subject: RE: [PATCH] video: Add a callback 'notify_after' for backlight control
To: "dilee@nvidia.com" <dilee@nvidia.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arun.murthy@stericsson.com" <arun.murthy@stericsson.com>,
        "rmorell@nvidia.com" <rmorell@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Cc: "jnien@nvidia.com" <jnien@nvidia.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20110809081813640@jg1.han
Msgkey: 20110809081813640@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110809081813640@jg1.han
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7656563.495631312878759566.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p798X0uo029360

> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of dilee@nvidia.com
> Sent: Tuesday, August 09, 2011 11:30 AM
> To: rpurdie@rpsys.net; lethal@linux-sh.org; akpm@linux-foundation.org;
> arun.murthy@stericsson.com; rmorell@nvidia.com;
> linus.walleij@stericsson.com
> Cc: jnien@nvidia.com; swarren@nvidia.com; linux-fbdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org; Dilan Lee
> Subject: [PATCH] video: Add a callback 'notify_after' for backlight
> control
> 
> From: Dilan Lee <dilee@nvidia.com>
> 
> We need a callback to do some things after pwm_enable, pwm_disable
> and pwm_config.
> 
> Signed-off-by: Dilan Lee <dilee@nvidia.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

I reviewed and tested the patch.
It works properly.

Thanks,
Jingoo Han

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
