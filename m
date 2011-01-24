Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1AXEir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:38:47 -0500
Received: from www.tglx.de ([62.245.132.106]:57724 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1AXEiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:38:46 -0500
Date: Mon, 24 Jan 2011 10:08:12 +0530
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH OF 13/14] rtc/cmos: add OF bindings
Message-ID: <20110124043812.GB20274@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-14-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1295843342-1122-14-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2011-01-24 09:59:01 [+0530]:

>diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
>index c7ff8df..2709e00 100644
>--- a/drivers/rtc/rtc-cmos.c
>+++ b/drivers/rtc/rtc-cmos.c
>@@ -1123,6 +1125,46 @@ static struct pnp_driver cmos_pnp_driver = {
> 
> #endif	/* CONFIG_PNP */
> 
>+#ifdef CONFIG_OF
>+static const struct of_device_id of_cmos_match[] = {
>+	{
>+		.compatible = "motorola,mc146818",
>+	},
>+	{ },
>+};

Andreas, this is the compatible string I'm using. Could you please tell
me what is OLPC using? So maybe we could stick to the same compatible
string.

Sebastian
