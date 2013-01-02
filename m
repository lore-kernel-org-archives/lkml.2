Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3ABR4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:56:15 -0500
Received: from fieldses.org ([174.143.236.118]:56478 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3ABR4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:56:12 -0500
Date: Wed, 2 Jan 2013 12:56:10 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Sage Weil <sage@inktank.com>
Cc: torvalds@linux-foundation.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for 3.8
Message-ID: <20130102175610.GA25274@fieldses.org>
References: <alpine.DEB.2.00.1212201319500.16508@cobra.newdream.net>
 <20121221185501.GA28092@fieldses.org>
 <alpine.DEB.2.00.1212211057000.28021@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1212211057000.28021@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:59:55AM -0800, Sage Weil wrote:
> On Fri, 21 Dec 2012, J. Bruce Fields wrote:
> > On Thu, Dec 20, 2012 at 01:29:49PM -0800, Sage Weil wrote:
> > > Hi Linus,
> > > 
> > > Please pull the following Ceph updates for 3.8 from
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus
> > > 
> > > There's a trivial conflict in net/ceph/osd_client.c dealing with rbtree 
> > > node initialization; the resolution is to keep the RB_CLEAR_NODE() call 
> > > (see 4c199a93 for the conflicting commit).
> > > 
> > > There are a few different groups of commits here.  The largest is Alex's 
> > > ongoing work to enable the coming RBD features (cloning, striping).  
> > > There is some cleanup in libceph that goes along with it.  Cyril and David 
> > > have fixed some problems with NFS reexport (leaking dentries and page 
> > > locks),
> > 
> > Just out of curiosity--what's the state of NFS exports now?
> > 
> > I seem to recall initially it was sort-of supported by filehandle
> > lookups didn't really work reliably?
> 
> That hasn't changed yet... if you miss both the client and MDS caches you 
> get ESTALE.  The MDS cache is big, so this works okay for casual use, but 
> it's not great.  This should be fixed on the server side of things for the 
> next major release (cuttlefish).  The client code shouldn't need to 
> change.

OK, thanks for the update.

--b.
