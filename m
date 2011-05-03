Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1ECWOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:14:53 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:53821 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1ECWOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:14:52 -0400
Date: Wed, 4 May 2011 00:14:40 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
Message-ID: <20110503221440.GB2737@local>
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
 <20110503203412.GA2119@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503203412.GA2119@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:34:12PM +0200, Wolfram Sang wrote:
> On Mon, May 02, 2011 at 08:51:55AM +0200, Michal Simek wrote:
> > Adding OF binding to genirq.
> > Version string is setup to the "devicetree".
> > 
> > Compatible string is not setup for now but you can add your
> > custom compatible string to uio_of_genirq_match structure.
> > 
> > For example with "vendor,device" compatible string:
> > static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> > 	{ .compatible = "vendor,device", },
> > 	{ /* empty for now */ },
> > };
> > 
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> [...]
> 
> > +		/* alloc uioinfo for one device */
> > +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> 
> kfree in remove?

Oh yes. Missed that one. It should probably look like the "bad0" case in probe().

Thanks,
Hans
