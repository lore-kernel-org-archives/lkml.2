Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0C0Vef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 17:34:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0C0Vee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 17:34:34 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Add Nehelem PMU programming errata workaround
From: Andi Kleen <andi@firstfloor.org>
References: <1269608924.12097.147.camel@laptop>
Date: Sat, 27 Mar 2010 22:27:55 +0100
In-Reply-To: <1269608924.12097.147.camel@laptop> (Peter Zijlstra's message of "Fri, 26 Mar 2010 14:08:44 +0100")
Message-ID: <87aattpi90.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> Subject: perf, x86: Add Nehelem PMU programming errata workaround
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Mar 26 13:59:41 CET 2010
>
> Implement the workaround for Intel Errata AAK100 and AAP53.
>
> Also, remove the Core-i7 name for Nehalem events since there are also
> Westmere based i7 chips.

Did you actually see this happen?

It looks like this will make the context switch into a perf
enabled process _MUCH_ more expensive, MSR writes are very slow.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
