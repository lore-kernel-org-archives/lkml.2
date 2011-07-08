Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1GHBiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:38:51 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32352
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab1GHBiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:38:50 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 8 Jul 2011 09:45:13 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] dt: add helper function to read u32 arrays
Message-ID: <20110708014512.GD12722@S2100-06.ap.freescale.net>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
 <20110706205933.GA5371@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110706205933.GA5371@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 02:59:33PM -0600, Grant Likely wrote:
> On Wed, Jul 06, 2011 at 03:42:58PM -0500, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > Rework of_property_read_u32 to read an array of values. Then
> > of_property_read_u32 becomes an inline with array size of 1.
> > 
> > Also make struct device_node ptr const.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Thomas Abraham <thomas.abraham@linaro.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > 
> > Grant, 
> > 
> > Perhaps you want to roll this into the original patch?
> 
> Applied, thanks.  The original is already in devicetree/next, so I've
> just applied this on top as a separate commit.
> 
> > 
> > It would also be nice if there were empty versions of the helpers
> > as well.
> 
> Go ahead and submit a patch to add them if you need it.
> 
I'm adding one into my spi-dt series, as I need it there.

-- 
Regards,
Shawn

