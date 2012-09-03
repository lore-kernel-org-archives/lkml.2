Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2ICPmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:42:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2ICPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:42:47 -0400
Subject: Re: [PATCH v2 0/9] Add device tree support for on-chip SRAM
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20120903015343.GB2362@S2101-09.ap.freescale.net>
References: <1346405224-20399-1-git-send-email-p.zabel@pengutronix.de>
	 <20120903015343.GB2362@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Sep 2012 17:42:34 +0200
Message-ID: <1346686954.2391.13.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Am Montag, den 03.09.2012, 09:53 +0800 schrieb Shawn Guo:
> I do not understand the point of introducing those imx patches, 1 ~ 4
> and 7, 8.  They are all unnecessary churns to me.  IMO, 4 patches are
> enough.
> 
>  * genalloc: add a global pool list, allow to find pools by phys address
>  * misc: Generic on-chip SRAM allocation driver
>  * ARM i.MX: remove IRAM_ALLOC facility
>  * ARM: dts: add sram for imx53 and imx6q
> 
> Regards,
> Shawn

Thanks, I thought that first making the iram_alloc API work would
decouple this a bit from the coda vpu patches that depend on sram
support on imx53/6q. I'll work in your comments and reduce the patch
count as you propose.

regards
Philipp


