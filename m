Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1GZFXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:23:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:30009 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GZFXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:23:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,267,1309762800"; 
   d="scan'208";a="30096359"
Date: Tue, 26 Jul 2011 13:23:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the writeback tree with the vfs
 tree
Message-ID: <20110726052303.GA3315@localhost>
References: <20110718173409.2885649b65937eb7caecf943@canb.auug.org.au>
 <20110726045812.GA32517@localhost>
 <20110726151451.e3385a5d969fddc210f186f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726151451.e3385a5d969fddc210f186f8@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Tue, Jul 26, 2011 at 01:14:51PM +0800, Stephen Rothwell wrote:
> Hi,
> 
> On Tue, 26 Jul 2011 12:58:12 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> > What should I do with the 2 conflicts for upstream merge?
> > 
> > I noticed that Linus just merged the vfs tree. So the obvious thing I
> > could do is to rebase writeback.git to Linus' tree and fix the
> > conflicts, and then ask Linus to pull the rebased writeback tree.
> > 
> > Or are there better practices?
> 
> Normally you just ask Linus to pull your tree and let him know that there
> are some conflicts and also ask him to let you know if he wants you to
> fix them up before merging.  He is a smart fellow, and if I worked it out,
> I am sure he can as well.  :-)
> 
> Some people pull Linus' tree into theirs and resolve the conflicts, but
> he prefers to do them himself usually.

Good point. Thank you for the nice guide!

Thanks,
Fengguang
