Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1JKJdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:33:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:48145 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab1JKJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,522,1312182000"; 
   d="scan'208";a="60992454"
Date: Tue, 11 Oct 2011 17:33:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the writeback tree
Message-ID: <20111011093308.GA1690@localhost>
References: <20111011195704.67c267dbb3c6eaaacf5d7a39@canb.auug.org.au>
 <20111011091725.GA31349@localhost>
 <20111011202736.2c0a7ac57a4a5c9c43564f13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011202736.2c0a7ac57a4a5c9c43564f13@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 05:27:36PM +0800, Stephen Rothwell wrote:
> Hi,
> 
> On Tue, 11 Oct 2011 17:17:25 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> > On Tue, Oct 11, 2011 at 04:57:04PM +0800, Stephen Rothwell wrote:
> > > 
> > > After merging the writeback tree, today's linux-next build (powerpc
> > > allnoconfig) produced these warnings:
> > > 
> > > mm/page-writeback.c: In function 'bdi_position_ratio':
> > > mm/page-writeback.c:622:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > page-writeback.c:635:4: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > 
> > > Introduced by commits 6c14ae1e92c7 ("writeback: dirty position control")
> > > and 8927f66c4ede ("writeback: dirty position control - bdi reserve area").
> > 
> > Ah sorry!  The below patch should fix it. Shall I update the original
> > commits in place, or append this patch as a new commit?
> 
> That choice is up to you as the maintainer of that tree.  Either works
> for me (appending is easier for you and me, and the warning is not a
> problem as far as bisection is concerned).

Got it!

> > Fix powerpc compile warnings
> > 
> > mm/page-writeback.c: In function 'bdi_position_ratio':
> > mm/page-writeback.c:622:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > page-writeback.c:635:4: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> If you do keep it separate, you could add a
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> above your SOB line.

OK!

Thanks,
Fengguang

