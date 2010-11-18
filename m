Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0KRDqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:46:02 -0500
Received: from ozlabs.org ([203.10.76.45]:47448 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0KRDqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:46:00 -0500
Date: Thu, 18 Nov 2010 14:41:45 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Jon Loeliger <jdl@jdl.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        John Bonesio <bones@secretlab.ca>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc
 repository
Message-ID: <20101118034145.GB7256@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Jon Loeliger <jdl@jdl.com>,
	Grant Likely <grant.likely@secretlab.ca>, glikely@secretlab.ca,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	John Bonesio <bones@secretlab.ca>, linuxppc-dev@lists.ozlabs.org
References: <20101116204917.12146.39851.stgit@riker>
 <20101116204951.12146.21084.stgit@riker>
 <20101117045935.GA12084@angua.secretlab.ca>
 <E1PIkEl-0006Zt-W7@jdl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PIkEl-0006Zt-W7@jdl.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 09:47:55AM -0600, Jon Loeliger wrote:
> > On Tue, Nov 16, 2010 at 12:49:51PM -0800, John Bonesio wrote:
> > > Pull in recent changes from the main dtc repository. These changes primarily
> > > allow multiple device trees to be declared which are merged by dtc. This
> > > feature allows us to include a basic dts file and then provide more informatio
> > n
> > > for the specific system through the merging functionality.
> > > 
> > > Signed-off-by: John Bonesio <bones@secretlab.ca>
> > 
> > Jon & David, I'll need your input on whether or not this is the best
> > way to handle updating the dtc copy in the kernel tree.
> > 
> > g.
> 
> Grant,
> 
> Yeah, I wondered too. :-)  David added it and updated
> in the kernel last round, so he may have some good notion
> of what would be best there.

For now I think just a direct diff updating the in-kernel dtc to
current upstream is the simplest approach.  This is how I made the
original commit.

There may be better methods to directly arrange for pulling of the dtc
git tree into the kernel git tree, but I have not had time to
investigate and set up such a scheme.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
