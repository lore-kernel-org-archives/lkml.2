Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2CNFiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:38:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2CNFiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:38:09 -0400
Date: Wed, 14 Mar 2012 13:38:16 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Zach Sadecki <zsadecki@itwatchdogs.com>,
        Rob Herring <robherring2@gmail.com>,
        Dong Aisheng <b29396@freescale.com>, vinod.koul@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        rdunlap@xenotime.net, shawn.guo@freescale.com, kernel@pengutronix.de,
        cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120314053814.GC21337@S2101-09.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <4F5F5B3F.2000303@gmail.com>
 <4F5F60DB.9090801@itwatchdogs.com>
 <20120313172807.AC4763E053B@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313172807.AC4763E053B@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:28:07AM -0600, Grant Likely wrote:
> On Tue, 13 Mar 2012 09:59:39 -0500, Zach Sadecki <zsadecki@itwatchdogs.com> wrote:
> > On 03/13/2012 09:35 AM, Rob Herring wrote:
> > > +	ahb@80080000 {
> > > +		fec@800f0000 {
> > > Use generic names: ethernet@800f0000
> > Generic is good, but consistency is better, IMHO.  grepping existing dts 
> > files in 3.2.9 finds 6 instances of "fec@" and 0 instances of "ethernet@"
> > >> +			uart1: uart@80074000 {
> > > Use generic names: uart1: serial@...
> > Same comment here, but unfortunately there is already inconsistency in 
> > existing files...  25 instances of "serial@" and 35 instances of "uart@"
> 
> No, Rob is correct.  The generic names recommended practice is well
> established and documented.  Expand your grep search to include
> arch/powerpc/bot/dts/*.
> 
> See section 2.2.2 of ePAPR[1]
> 
> [1]https://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.1.pdf
> 
I will probably need to patch imx5 and imx6 dts files with the
inconsistency fixed.

-- 
Regards,
Shawn
