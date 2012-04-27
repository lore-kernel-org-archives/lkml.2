Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab2D0I0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:26:40 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:41189 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2D0I0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:26:35 -0400
Date: Fri, 27 Apr 2012 16:26:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl
 subsystem
Message-ID: <20120427082623.GU2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-4-git-send-email-b29396@freescale.com>
 <20120427073504.GS17184@pengutronix.de>
 <20120427082930.GC826@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427082930.GC826@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:29:31PM +0800, Dong Aisheng wrote:
> You meant add provide_dummies call in imx*_soc_init call?
> We could do it but there might be a case that some boards are converted
> to use pinctrl while others still not but they're based on the same soc.
> For examples, 4 mx53 boards and we may not be able to convert them all at
> the same time.
> 
Only non-DT boot will call imx*_soc_init, while DT boot will not.  And
imx pinctrl only supports DT.

-- 
Regards,
Shawn
