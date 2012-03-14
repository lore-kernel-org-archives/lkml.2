Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2CNI3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:29:05 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5772
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab2CNI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:28:56 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 16:30:47 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Huang Shijie-B32955 <B32955@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH v1 5/5] ARM: mxs: add mxs dma dt support
Message-ID: <20120314083046.GD1180@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-6-git-send-email-b29396@freescale.com>
 <4F604F9F.1070801@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F604F9F.1070801@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:58:23PM +0800, Huang Shijie-B32955 wrote:
> Hi,
> > +			dma-apbh@80004000 {
> > +				compatible = "fsl,mxs-dma-apbh";
> > +				reg =<0x80004000 2000>;
> > +			};
> > +
> Why you do not add the `interrupt` for the it?
> the gpmi-nand needs to parse the interrupt out.
> 
The non-dt way also does not have interrupt resource for dma device.
It seems the channel interrupt resource is handled in each client device.
I'm not familiar with gpmi-nand, but I guess you may need to handle
it in gpmi driver, just like mxs-mmc driver.

Regards
Dong Aisheng

