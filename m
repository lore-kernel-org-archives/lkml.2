Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2LUSzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:55:09 -0500
Received: from fieldses.org ([174.143.236.118]:53958 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2LUSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:55:04 -0500
Date: Fri, 21 Dec 2012 13:55:01 -0500
To: Sage Weil <sage@inktank.com>
Cc: torvalds@linux-foundation.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for 3.8
Message-ID: <20121221185501.GA28092@fieldses.org>
References: <alpine.DEB.2.00.1212201319500.16508@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1212201319500.16508@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 01:29:49PM -0800, Sage Weil wrote:
> Hi Linus,
> 
> Please pull the following Ceph updates for 3.8 from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus
> 
> There's a trivial conflict in net/ceph/osd_client.c dealing with rbtree 
> node initialization; the resolution is to keep the RB_CLEAR_NODE() call 
> (see 4c199a93 for the conflicting commit).
> 
> There are a few different groups of commits here.  The largest is Alex's 
> ongoing work to enable the coming RBD features (cloning, striping).  
> There is some cleanup in libceph that goes along with it.  Cyril and David 
> have fixed some problems with NFS reexport (leaking dentries and page 
> locks),

Just out of curiosity--what's the state of NFS exports now?

I seem to recall initially it was sort-of supported by filehandle
lookups didn't really work reliably?

--b.

> and there is a batch of patches from Yan fixing problems with the 
> fs client when running against a clustered MDS.  There are a few bug fixes 
> mixed in for good measure, many of which will be going to the stable trees 
> once they're upstream.
> 
> My apologies for the late pull.  There is still a gremlin in the rbd 
> map/unmap code and I was hoping to include the fix for that as well, but 
> we haven't been able to confirm the fix is correct yet; I'll send that in 
> a separate pull once it's nailed down.
