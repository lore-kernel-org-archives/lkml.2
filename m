Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1CCABR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:01:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1CCABQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:01:16 -0500
Date: Thu, 3 Mar 2011 01:01:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] ACPI, APEI patches for 2.6.39
Message-ID: <20110303000112.GG32215@one.firstfloor.org>
References: <1298267685-7357-1-git-send-email-ying.huang@intel.com> <alpine.LFD.2.02.1103021750250.12344@x980>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103021750250.12344@x980>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:51:24PM -0500, Len Brown wrote:
> On Mon, 21 Feb 2011, Huang Ying wrote:
> 
> > [PATCH 1/7] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
> > [PATCH 2/7] lib, Add lock-less NULL terminated single list
> > [PATCH 3/7] ACPI, APEI, Add ERST record ID cache
> > [PATCH 4/7] PCIe, AER, use pre-generated prefix in error information printing
> > [PATCH 5/7] ACPI, APEI, Add PCIe AER error information printing support
> > [PATCH 6/7] lib, Make gen_pool memory allocator lockless
> > [PATCH 7/7] ACPI, APEI, GHES, printk support for recoverable error via NMI
> 
> I've put this series into acpi-test, so it will be visible in linux-next;
> but I'm not the right person to review the generic lockless stuff,
> who is?

I reviewed it earlier and it seemed good to me (unless it has 
changed), but Linus wanted non Intel reviewers too. Any takers?

-Andi
