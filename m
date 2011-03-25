Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1CYRWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:22:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1CYRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:22:18 -0400
Date: Fri, 25 Mar 2011 18:22:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Message-ID: <20110325172217.GP21838@one.firstfloor.org>
References: <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu> <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu> <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org> <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com> <20110324235654.GM21838@one.firstfloor.org> <1301032040.2714.569.camel@edumazet-laptop> <20110325093228.GB13640@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325093228.GB13640@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you please try the patch below?

This is very likely not a good idea.  I heard some systems can hang
if you overwrite their PMUs this way and you're unlucky enough :-(

-Andi
