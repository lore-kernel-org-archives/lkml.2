Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab2DYMBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:01:07 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:24526
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157Ab2DYMBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:01:05 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz1102I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 25 Apr 2012 20:10:53 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>,
        <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 1/3] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120425121052.GD17631@shlinux2.ap.freescale.net>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334933916-12971-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 10:58:34PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
> 
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
> 
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
I will send out an updated version with minor dt fix
(SION bit in mux missed from v2, thanks for Richard's report).

Regards
Dong Aisheng

