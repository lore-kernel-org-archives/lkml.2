Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2FQDff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 23:35:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:15615 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab2FQDfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 23:35:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166557969"
Date: Sun, 17 Jun 2012 11:35:27 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reducing the noise level of build error notifications to 0
Message-ID: <20120617033527.GA7953@localhost>
References: <4fdbcd2f.Ta8kRp58FRzqrqaL%wfg@linux.intel.com>
 <20120616011646.GA7847@localhost>
 <20120616014732.GA2981@kroah.com>
 <20120616025031.GA8182@localhost>
 <20120616034420.GA3748@kroah.com>
 <20120616041144.GA8666@localhost>
 <20120616042010.GA8979@localhost>
 <20120616152720.GA7914@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616152720.GA7914@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 08:27:20AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jun 16, 2012 at 12:20:10PM +0800, Fengguang Wu wrote:
> > > > How about also cc: not only the author where you mention it above, but
> > > > everyone who signed-off on the patch?  That would provide a bit of peer
> > > > pressure to ensure that the problems get fixed.
> > > 
> > > That's (interesting and) good point. If me understand you right:
> > > 
> > > - TO: author, CC: Signed-off-by, CC: (sub-)subsystem mailing list
> > >   for build errors
> > > 
> > > - TO: author, CC: Signed-off-by (but sure, remove the top level busy maintainers)
> > >   for gcc warnings
> 
> Well, if I sign-off on a patch, I want to know about gcc warnings that
> were added by it, don't not email me just because you think I'm busy.

OK :)

> > Or, just remove the committer from CC: and add Reviewed-by to CC: 
> > By reviewing, one should already be familiar with the patch.
> 
> I don't think you should drop the committer, but maybe that's just me.

Understand. Let's default to CC all signers and committer.

> > > - TO: author
> > >   for sparse warnings (however I'm still too afraid to enable sparse checks)
> 
> This might get tougher in some areas of the kernel like the
> drivers/staging/ tree where people incrementally fix things up, like fix
> trailing space issues on one patch, which doesn't change the rest of the
> line that might have had coding style or sparse issues in it.  That's
> why I can't always run checkpatch.pl on patches sent to me, and why
> sparse might not help out.

Ah got it.

> But, I'd love to see sparse run on other areas of the kernel (i.e.
> anything not in drivers/staging/) hopefully it would get those areas
> fixed up properly.

Sure, I can blacklist the staging tree and still do sparse
notifications for others.

Thanks,
Fengguang
