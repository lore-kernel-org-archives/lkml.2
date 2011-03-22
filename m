Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1CVDBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:01:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:14154 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1CVDBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,223,1299484800"; 
   d="scan'208";a="722689234"
Subject: Re: [PATCH 0/7] ACPI, APEI patches for 2.6.39
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20110303000112.GG32215@one.firstfloor.org>
References: <1298267685-7357-1-git-send-email-ying.huang@intel.com>
	 <alpine.LFD.2.02.1103021750250.12344@x980>
	 <20110303000112.GG32215@one.firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 22 Mar 2011 11:01:32 +0800
Message-ID: <1300762892.3616.12.camel@yhuang-mobile.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

On Thu, 2011-03-03 at 08:01 +0800, Andi Kleen wrote:
> On Wed, Mar 02, 2011 at 05:51:24PM -0500, Len Brown wrote:
> > On Mon, 21 Feb 2011, Huang Ying wrote:
> > 
> > > [PATCH 1/7] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
> > > [PATCH 2/7] lib, Add lock-less NULL terminated single list
> > > [PATCH 3/7] ACPI, APEI, Add ERST record ID cache
> > > [PATCH 4/7] PCIe, AER, use pre-generated prefix in error information printing
> > > [PATCH 5/7] ACPI, APEI, Add PCIe AER error information printing support
> > > [PATCH 6/7] lib, Make gen_pool memory allocator lockless
> > > [PATCH 7/7] ACPI, APEI, GHES, printk support for recoverable error via NMI
> > 
> > I've put this series into acpi-test, so it will be visible in linux-next;
> > but I'm not the right person to review the generic lockless stuff,
> > who is?
> 
> I reviewed it earlier and it seemed good to me (unless it has 
> changed), but Linus wanted non Intel reviewers too. Any takers?

As for

[PATCH 1/7] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH 2/7] lib, Add lock-less NULL terminated single list
[PATCH 6/7] lib, Make gen_pool memory allocator lockless

they are general kernel patches.  I remember you have reviewed some
earlier version of these patches, and merged 1/2 into -mm tree.  Do you
have time to review these patches?  Although Andi has reviewed them, we
really need some non-Intel reviewers.

Thanks,
Huang Ying
b

