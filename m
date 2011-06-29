Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1F2Upp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:45:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:41920 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab1F2Upm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:45:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,445,1304319600"; 
   d="scan'208";a="22052415"
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
Date: Wed, 29 Jun 2011 13:44:19 -0700
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> (Jeremy
	Fitzhardinge's message of "Thu, 16 Jun 2011 14:40:47 -0700")
Message-ID: <m2pqlw1i70.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> I couldn't measure a consistent performance difference between the two
> implemenations; there seemed to be +/- ~1% +/-, which is the level of
> variation I see from simply recompiling the kernel with slightly
> different code alignment.

I ran your new locks in my lock tester and I have a similar experience.
There's some variation, but it seems to be in the usual variance.
In some cases the C locks were actually faster.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
