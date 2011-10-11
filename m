Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1JKGYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:24:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1JKGYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:24:42 -0400
Date: Tue, 11 Oct 2011 08:22:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111011062253.GA3589@elte.hu>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu>
 <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> > Andrew?
> 
> I think I know what the root cause is and I have most of a patch to 
> fix it.  It doesn't compile (yet), it's a little less trivial than 
> I'd like for something this late in the -rc cycle, and it adds 16 
> bytes to thread_struct (ugh!).
> 
> I think I can make a follow-up patch that removes 32 bytes of 
> per-thread state to restore my karma, though, but that will 
> definitely not be 3.1 material.

Ok, i've queued up the vsyscall=native patch in tip:x86/urgent for 
now - we can re-try in v3.2 (perhaps) if a satisfactory solution is 
found.

Thanks,

	Ingo
