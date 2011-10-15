Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1JOQ7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 12:59:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1JOQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 12:59:44 -0400
Date: Sat, 15 Oct 2011 18:57:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fixing the UML failure root cause
Message-ID: <20111015165757.GA29782@elte.hu>
References: <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu>
 <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
 <20111011062253.GA3589@elte.hu>
 <4E947BC9.7040805@mit.edu>
 <CAFLxGvw3KfPCwGbh+80PLYu9DNELvcyY1uHZRncKuRwtX2uc2g@mail.gmail.com>
 <CAObL_7E-ZpRZqL3D2OoE81-46JU2-dcOO6ywYLzAJJRuP_7Ssw@mail.gmail.com>
 <CAFLxGvxgDQDzgWHZxS5m+9m84dsONEdmmmZhpsvVfRUH5CYTFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvxgDQDzgWHZxS5m+9m84dsONEdmmmZhpsvVfRUH5CYTFQ@mail.gmail.com>
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



* richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Fri, Oct 14, 2011 at 10:17 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> > On Fri, Oct 14, 2011 at 12:53 PM, richard -rw- weinberger
> > <richard.weinberger@gmail.com> wrote:
> >> On Tue, Oct 11, 2011 at 7:24 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >>> What do you think of this approach?  If it seems good, I'll finish the
> >>> patch and submit it.
> >>>
> >>> With this patch applied, UML appears to work, but it fills the log with
> >>> exploit attempt warnings.  Any ideas on what to do about that?
> >>>
> >>
> >> I can confirm that this patch works.
> >> And I really like vsyscall=emulate because with that UML can trap vsyscalls. :-)
> >
> > Are you sure you don't mean vsyscall=native?  I suspect that UML can't
> > actually trap vsyscalls in emulate mode right now, although that ought
> > to be fixable.
> >
> 
> §/%)"&!, you are so right!
> I missed that vsyscall=native is the default setting now.
> Sorry for the confusion.

Switch back to vsyscall=native was just a temporary ABI fix for v3.1 
- we'd like to switch to vsyscall=emulate again ASAP (possibly in 
v3.2), once Andrew is done with the patch and everyone is happy with 
it.

Thanks,

	Ingo
