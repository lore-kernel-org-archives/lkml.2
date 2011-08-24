Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1HXUAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:00:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:42744 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1HXUAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="41851311"
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
	<c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com>
Date: Wed, 24 Aug 2011 13:00:48 -0700
In-Reply-To: <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com>
	(Jeremy Fitzhardinge's message of "Wed, 24 Aug 2011 10:53:00 -0700")
Message-ID: <m2pqjud1fz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Make trylock code common regardless of ticket size.

Can't we just get rid of the small ticket size code path?

I couldn't benchmark any difference between the two last time 
I tried.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
