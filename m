Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1CXVhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:37:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34477 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab1CXVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:37:45 -0400
Date: Thu, 24 Mar 2011 22:37:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Message-ID: <20110324213744.GL21838@one.firstfloor.org>
References: <201103241026.01624.knikanth@suse.de> <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com> <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu> <m2sjucl0a6.fsf@firstfloor.org> <20110324205038.GA2393@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324205038.GA2393@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that case the second example i quoted can be used:
> 
>   perf top -e L1-dcache-store-misses -e L1-dcache-stores --count-filter 10

That will include L2 and L3 stores -- you won't get any indication 
on misses to other sockets.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
