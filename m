Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1GVQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:27:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:11557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1GVQ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:27:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,248,1309762800"; 
   d="scan'208";a="31239103"
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
	<m2pqlw1i70.fsf@firstfloor.org> <4E28B749.10304@goop.org>
Date: Fri, 22 Jul 2011 09:25:34 -0700
In-Reply-To: <4E28B749.10304@goop.org> (Jeremy Fitzhardinge's message of "Thu,
	21 Jul 2011 16:33:29 -0700")
Message-ID: <m2d3h22sg1.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> Yes, I observed cases where they were faster.  What is your lock
> tester?  Does it test the lock code in isolation, or in situ?

User space harness to test a couple of lock scenarios with different
numbers of CPUs competing.

It tests the lock code in isolation.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
