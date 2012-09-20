Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2ITWTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:19:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61731 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2ITWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:19:23 -0400
Date: Thu, 20 Sep 2012 15:16:38 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] power_supply: add new lp8788 charger driver
Message-ID: <20120920221638.GF18223@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF2227@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF2227@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:43:21AM +0000, Kim, Milo wrote:
>  TI LP8788 PMU supports regulators, battery charger, RTC,
>  ADC, backlight driver and current sinks.
> 
>  This patch supports the charger operations including
>  the charger interrupt handling.
[...]
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---

Had to fix a bunch of checkpatch complaints:

CHECK: space prohibited before semicolon
#478: FILE: drivers/power/lp8788-charger.c:396:
+       for (i = 0 ; i < pdata->num_chg_params ; i++) {

CHECK: space prohibited before semicolon
#541: FILE: drivers/power/lp8788-charger.c:459:
+       for (i = 0 ; i < pchg->num_irqs ; i++) {


But other than this, it looks really good, this is now applied.

Obviously, I couldn't compile-test it, but hopefully it will work
once MFD part is also in. :-) If not, you can just send a follow-up
fix.

Thanks!
