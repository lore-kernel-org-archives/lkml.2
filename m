Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2HaOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:39:39 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:39160
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab2HaOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:39:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh87h2a8h668h839h944hd25hd2bhe96hf0ah107ah1220h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 31 Aug 2012 09:39:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 7/7] mfd: anatop-mfd: remove anatop driver
Message-ID: <20120831013924.GB7726@r65073-Latitude-D630>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-8-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346237818-9498-8-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:56:58PM +0800, Dong Aisheng wrote:
> -config MFD_ANATOP
> -	bool "Support for Freescale i.MX on-chip ANATOP controller"
> -	depends on SOC_IMX6Q
> -	help
> -	  Select this option to enable Freescale i.MX on-chip ANATOP
> -	  MFD controller. This controller embeds regulator and
> -	  thermal devices for Freescale i.MX platforms.
> -

All the occurrences of MFD_ANATOP should be removed too.  I know there
is one in arch/arm/mach-imx/Kconfig.

Regards,
Shawn

