Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1FSHml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 03:42:41 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:30934
	"EHLO CH1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751774Ab1FSHmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 03:42:39 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275ch8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sun, 19 Jun 2011 15:46:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>, <patches@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Jason Liu <jason.hui@linaro.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] net/fec: add device tree support
Message-ID: <20110619074658.GD23171@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-3-git-send-email-shawn.guo@linaro.org>
 <20110618162220.GI8195@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110618162220.GI8195@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 10:22:20AM -0600, Grant Likely wrote:
> On Sat, Jun 18, 2011 at 11:19:13PM +0800, Shawn Guo wrote:
> > It adds device tree data parsing support for fec driver.
> > 
> > Signed-off-by: Jason Liu <jason.hui@linaro.org>
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> >  Documentation/devicetree/bindings/net/fsl-fec.txt |   14 ++++++++++
> >  drivers/net/fec.c                                 |   28 +++++++++++++++++++++
> >  2 files changed, 42 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> > new file mode 100644
> > index 0000000..705111d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> > @@ -0,0 +1,14 @@
> > +* Freescale Fast Ethernet Controller (FEC)
> > +
> > +Required properties:
> > +- compatible : should be "fsl,<soc>-fec", "fsl,fec"
> 
> Ditto to comment on last patch.  "fsl,fec" is to generic.
> "fsl,imx51-soc" should be the generic value.
> 

Ditto to the feedback on the last comment.  "fsl,imx51-fec" is not
a good one to be the compatibility string for imx27 and imx35 fec.

> Otherwise looks okay to me, and I don't see any problem with queueing
> it up for v3.1 with that change since it doesn't depend on any other
> patches.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 

-- 
Regards,
Shawn

