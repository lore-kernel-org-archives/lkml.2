Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1FSN40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:56:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:65145 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab1FSN4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,388,1304319600"; 
   d="scan'208";a="15412978"
Date: Sun, 19 Jun 2011 21:56:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: 3.0-rc3: WARNING: at fs/fs-writeback.c:356
 writeback_single_inode+0x3e/0x18f()
Message-ID: <20110619135618.GA4545@localhost>
References: <alpine.SOC.1.00.1106141213570.11764@math.ut.ee>
 <1308112976.2635.27.camel@pasglop>
 <20110618173355.GB4652@localhost>
 <1308438438.32158.62.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308438438.32158.62.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 07:07:18AM +0800, Benjamin Herrenschmidt wrote:
> On Sun, 2011-06-19 at 01:33 +0800, Wu Fengguang wrote:
> > Hi Benjamin,
> > 
> > On Wed, Jun 15, 2011 at 02:42:56PM +1000, Benjamin Herrenschmidt wrote:
> > > On Tue, 2011-06-14 at 12:15 +0300, Meelis Roos wrote:
> > > > Tested 3.0-rc3 on my PC (2 PATA disks, single duron CPU). Got several of 
> > > > these in dmesg:
> > > 
> > > Same here on a powerpc64 machine while doing a fresh debian install
> > > (while the installer's installing the packages), -rc3 as well.
> > 
> > Do you have some clue that this bug show up in between 3.0-rc1 and
> > 3.0-rc3, or between 2.6.39 and 3.0-rc3?
> 
> No idea. I just noticed that as I was re-installing debian on a machine
> (to track down another problem actually).
> 
> Maybe Meelis has more data.

OK, thanks.

Andi/Meelis, what's your kconfig? Hope that can give me more better
opportunity to reproduce the bug.

Thanks,
Fengguang
