Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1AVR2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 12:28:34 -0500
Received: from www.tglx.de ([62.245.132.106]:55092 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1AVR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 12:28:33 -0500
Date: Sat, 22 Jan 2011 18:28:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pekka Enberg <penberg@kernel.org>
cc: Dima Zavin <dmitriyz@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
In-Reply-To: <AANLkTikrDxtkVFJ0C-SwH9QCq4m0A2KMp0vAFA=PaSGM@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101221802280.31804@localhost6.localdomain6>
References: <1295576730.4096.24.camel@Joe-Laptop> <1295624801.19880.13.camel@m0nster> <20110121094827.41818a55@jbarnes-desktop> <20110121095658.1ab623fe@jbarnes-desktop> <1295632828.19880.22.camel@m0nster> <20110121100441.06a94482@jbarnes-desktop>
 <1295633882.19880.31.camel@m0nster> <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com> <1295642995.19880.42.camel@m0nster> <AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com> <20110121234930.GK3043@thunk.org> <1295684398.19231.47.camel@jaguar>
 <AANLkTinEnNYjhA2WRD=1AqmHYY3ec0uJxRVmLW57_EU=@mail.gmail.com> <AANLkTikrDxtkVFJ0C-SwH9QCq4m0A2KMp0vAFA=PaSGM@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Pekka Enberg wrote:

> Hi Dima!
> 
> On Sat, Jan 22, 2011 at 12:35 PM, Dima Zavin <dmitriyz@google.com> wrote:
> > There's absolutely no hostility. I stated from the very beginning that
> > I appreciate the voluntary effort by a 3rd party to upstream the board
> > files. I only asked that proper authorship be attributed, which is
> > standard linux kernel patch submission procedure when the committer
> > did not originate the code.
> 
> OK, that's great! It's poorly reflected in this discussion thread, though.
> 
> >> who have been sitting on these patches for over a year now AFAICT.
> >
> > Even if that were true, that does not somehow revoke the original
> > author/contributor list.
> 
> No, it does not. But it does make me much more sympathetic towards
> Daniel's efforts even though authorship info is misappropriated. It's
> not as if he changed copyrights or anything malicious like that so I
> do think people are making this into a bigger thing than it really is.
> 
> Anyway, I hope Daniel has the time to rebase his patches on top of
> your original ones so history is preserved and we can get this stuff
> merged.

Crap. There is no history which has remotely to do anything with
Daniel patches, which are btw. very sensible and well done.

Patch 1/7 is extracted from one large dump (f5ee31ab10c1) in the
android tree, which has:

	9 files changed, 1445 insertions(+), 45 deletions(-)

versus Daniels patch:

       1 files changed, 42 insertions(+), 0 deletions(-)

Patch 2/7 is properly assigned to the original author.

Patch 3/7 is extracted from another large dump (37431502c4) in the
android tree which has:

      11 files changed, 5336 insertions(+), 6 deletions(-)

versus Daniels patch:

       4 files changed, 484 insertions(+), 1 deletions(-)

And if you look at the above 37431502c4 commit then you'll notice that
the author is Dima Zavin <dima@android.com>, while in fact the whole
commit is a conglomerate of commits from some other place with 16
different authors, but there is no way to identify who wrote what.

How the f*ck should Daniel attribute the authorship from that shit
pile? And the person who "authored" that mega commit is now
complaining.

I stoppped looking at this point as the whole "so well done" android
tree is a huge stinking pile of sh*t! Not only code wise, also the
history is completely useless due to these mega commits which have no
reference at all.

The only thing what Daniel missed is to add in the change log of his
patches:

	Extracted from: git-url branch commit ID
or:
	Based on: git-url branch commit ID

That's oversight and not a malicious crime and easy to repair.

The people who make a lot of noise about this including you did not
even bother to look at the patches and the originating mess, which is
in no way suitable to go near mainline in any form.

I really appreciate the well structured effort which Daniel is putting
into this. An effort which should have been done in the first place by
those who cry murder now.

Thanks,

	tglx
