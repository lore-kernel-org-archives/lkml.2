Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2CNHdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:33:39 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:16681
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab2CNHdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:33:37 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz103dK1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 15:34:55 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <b29396@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <vinod.koul@linux.intel.com>,
        <s.hauer@pengutronix.de>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rdunlap@xenotime.net>,
        <kernel@pengutronix.de>, <cjb@laptop.org>, <shawn.guo@freescale.com>
Subject: Re: [PATCH v1 0/5] dt: add basic imx28 support
Message-ID: <20120314073454.GD8494@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <201203140701.07111.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201203140701.07111.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 07:01:06AM +0100, Marek Vasut wrote:
> Dear Dong Aisheng,
> 
> > This patch series adds basic imx28 dt support including fec, mmc and dma.
> > 
> > Tested on mx28evk.
> > 
> > TODO:
> > Convert the remaining devices to support dt.
> > mxs-auart, mxs-gpio, i2c, flexcan, saif, rtc, pwm, fb.
> > 
> > Dong Aisheng (5):
> >   ARM: imx28: add basic dt support
> >   mmc: mxs-mmc: add dt probe support
> >   ARM: imx28evk: add mmc dt support
> >   dma: mxs-dma: add dt probe support
> >   ARM: mxs: add mxs dma dt support
> > 
> Can you keep me in Cc on new versions of these patches? Thanks!
> 
Of course yes.
Thanks for your review.

Regards
Dong Aisheng

