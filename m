Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1CXX47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:56:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1CXX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:56:58 -0400
Date: Fri, 25 Mar 2011 00:56:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Message-ID: <20110324235654.GM21838@one.firstfloor.org>
References: <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com> <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu> <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu> <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org> <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> never EVER seen any good explanation of why that particular sh*t
> argument would b true. It seems to be purely about politics, where
> some idiotic vendor (namely HP) has convinced Intel that they really
> need it. To the point where some engineers seem to have bought into
> the whole thing and actually believe that fairy tale ("firmware can do
> better" - hah! They must be feeding people some bad drugs at the
> cafeteria)

For the record I don't think it's a good idea for the BIOS to do 
this (and I'm not aware of any engineer who does),  
but I think Linux should do better than just disabling PMU use when 
this happens.

However I suspect taking over SCI would cause endless problems
and is very likely not a good idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
