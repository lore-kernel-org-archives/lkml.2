Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HIDoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:44:15 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:42029 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab1HIDoN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:44:13 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: "dilee@nvidia.com" <dilee@nvidia.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rmorell@nvidia.com" <rmorell@nvidia.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "jnien@nvidia.com" <jnien@nvidia.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 9 Aug 2011 05:43:25 +0200
Subject: RE: [PATCH] video: Add a callback 'notify_after' for backlight
 control
Thread-Topic: [PATCH] video: Add a callback 'notify_after' for backlight
 control
Thread-Index: AcxWPF6t7mNyFd0uTUWX9TeIfuHVxAACfRLA
Message-ID: <F45880696056844FA6A73F415B568C6953FF062B94@EXDCVYMBSTM006.EQ1STM.local>
References: <1312856996-22452-1-git-send-email-dilee@nvidia.com>
In-Reply-To: <1312856996-22452-1-git-send-email-dilee@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: dilee@nvidia.com [mailto:dilee@nvidia.com]
> Sent: Tuesday, August 09, 2011 8:00 AM
> To: rpurdie@rpsys.net; lethal@linux-sh.org; akpm@linux-foundation.org;
> Arun MURTHY; rmorell@nvidia.com; Linus WALLEIJ
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

Reviewed-by: Arun Murthy <arun.murthy@stericsson.com>

