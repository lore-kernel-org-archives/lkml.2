Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1FICSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:18:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:47332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1FICS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="11533653"
Date: Thu, 9 Jun 2011 10:18:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Subject: Re: [PATCH 00/15] writeback fixes and cleanups for 3.0 (v5)
Message-ID: <20110609021825.GA5313@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607160441.db475211.akpm@linux-foundation.org>
 <20110608020102.GA29239@localhost>
 <20110608134510.GA10273@localhost>
 <20110609111609.45848768.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609111609.45848768.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jun 09, 2011 at 09:16:09AM +0800, Stephen Rothwell wrote:
> Hi,
> 
> On Wed, 8 Jun 2011 21:45:10 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git#fs-writeback
> > 
> > Will you include this branch instead? It looks more reasonable as
> > suggested by Sedat:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git  next
> 
> I have added that tree starting today with just you as the contact
> (please let me know if others should be added as contacts as well).

Thank you!

> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window. 
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.

OK.

Thanks,
Fengguang
