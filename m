Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2DMFfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 01:35:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9273 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DMFf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 01:35:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 12 Apr 2012 22:35:28 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Hannu Heikkinen <hannuxx@iki.fi>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>
Date: Fri, 13 Apr 2012 11:05:23 +0530
Subject: RE: [PATCH] rtc: tegra: cleanup probe/remove routines
Thread-Topic: [PATCH] rtc: tegra: cleanup probe/remove routines
Thread-Index: Ac0Ysyug/+idoXHGQ9SaIiiqJST56AAg4dAQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD67586A0@BGMAIL02.nvidia.com>
References: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
In-Reply-To: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (info->tegra_rtc_irq <= 0)
> +		return -EBUSY;
Interrupt support is needed only for wake up or timer support.
Apart from them RTC can be used for reference time keeping.

So, is it not good to print a warn message as "wake up
with alarm is not supported" and proceed further instead of 
returning failure from the driver itself?

