Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1HLAri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:47:38 -0400
Received: from trinity.fluff.org ([89.16.178.74]:34503 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1HLArh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:47:37 -0400
Date: Fri, 12 Aug 2011 01:47:32 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Ben Dooks <ben-i2c@fluff.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Subject: Re: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
	empty of_get_property for non-dt)
Message-ID: <20110812004732.GF19115@trinity.fluff.org>
References: <74CDBE0F657A3D45AFBB94109FB122FF04A0687289@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04A0687289@HQMAIL01.nvidia.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 09:21:31AM -0700, Stephen Warren wrote:
> Stephen Warren wrote at Monday, August 08, 2011 1:26 PM:
> > Rob Herring wrote at Sunday, August 07, 2011 8:38 AM:
> > > On 08/05/2011 05:50 PM, Stephen Warren wrote:
> > > > The patch adds empty function of_get_property for non-dt build, so that
> > > > drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> > > >
> > > > This also fixes the current Tegra compile problem in linux-next.
> > >
> > > You could just use of_property_read_u32 in the driver. It already has
> > > empty version and will simplify the driver code some.
> > 
> > Yes, that would also work.
> > 
> > Grant, Ben, do you have a preference for which option to choose?
> 
> Well, all three possible fixes have been posted now:
> 
> Add ifdef to i2c driver:
> http://www.spinics.net/lists/linux-tegra/msg01720.html
> 
> Implement empty of_get_property:
> http://www.spinics.net/lists/linux-tegra/msg01881.html
> 
> Switch i2c driver to use of_property_read_u32:
> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/127807
> 
> Ben, please could you please pick one of the changes and apply it, so
> that linux-next compiles for Tegra? Thanks!

I'll look into this at the weekend, of_property_read_u32 is probably
a better function to call.
 
> -- 
> nvpublic
> 

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

