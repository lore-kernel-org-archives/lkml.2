Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1HBSR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:17:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:44610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1HBSRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="35057150"
Date: Tue, 2 Aug 2011 11:17:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
Message-ID: <20110802181751.GB7087@tassilo.jf.intel.com>
References: <20110801215908.GA11448@tassilo.jf.intel.com>
 <87sjpk9ttf.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjpk9ttf.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:05:48AM +0200, Sven Joachim wrote:
> On 2011-08-01 23:59 +0200, Andi Kleen wrote:
> 
> > The longterm Linux kernel 2.6.35.14 is released.
> >
> > A note on the 2.6.35.13 git tags & branches: when releasing 2.6.35.13 I made
> > a mistake which resulted in the v2.6.35.13 tag being on a different
> > branch than the master tree.  I decided the continue on the branch,
> > not the tag, so you have to delete the v2.6.35.13 tag -- if you're
> > using that -- and refetch the new tag. If you just use the "master" branch
> > or the released patches/tarballs you don't need to do anything. Sorry about that.
> 
> Well, there is still a little problem with the git repository.  You have
> pushed the tag but not the master branch to git.kernel.org.

I checked the tree on master, it is uptodate. Don't know why it's 
not reaching the main git server. Maybe have to wait a bit longer.

-Andi
