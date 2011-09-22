Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1IVRG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:06:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51635 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1IVRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:06:26 -0400
Date: Thu, 22 Sep 2011 11:06:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110922170622.GI17168@ponder.secretlab.ca>
References: <20110921204545.19871.99088.stgit@ponder>
 <20110922065307.GB27978@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922065307.GB27978@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 02:53:08PM +0800, Shawn Guo wrote:
> On Wed, Sep 21, 2011 at 02:46:54PM -0600, Grant Likely wrote:
> > From: Shawn Guo <shawn.guo@linaro.org>
> > 
> > The patch adds function of_alias_scan to populate a global lookup
> > table with the properties of 'aliases' node and function
> > of_alias_get_id for drivers to find alias id from the lookup table.
> > 
> > v3: Split out automatic addition of aliases on id lookup so that it can be
> >     debated separately from the core functionality.
> > v2: - Add of_chosen/of_aliases populating and of_alias_scan() invocation
> >     for OF_PROMTREE.
> >     - Add locking
> >     - rework parse loop
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
> On imx serial driver:
> 
> Tested-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Hi Grant,
> 
> I just posted a patch to have of_alias_get_id() back for imx serial
> driver with replying to this one.  Can you please merge it to through
> your tree as well?

No problem.

g.

 
