Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1J1Mdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:33:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab1J1Mdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:33:44 -0400
X-Greylist: delayed 17384 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 08:33:44 EDT
Date: Fri, 28 Oct 2011 14:29:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111028122902.GA25323@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <20111027193448.GA3514@merkur.ravnborg.org>
 <20111028070336.GF12995@elte.hu>
 <CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com>
 <20111028075432.GB8626@elte.hu>
 <20111028120856.GA29174@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028120856.GA29174@citd.de>
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


* Matthias Schniedermeyer <ms@citd.de> wrote:

> On 28.10.2011 09:54, Ingo Molnar wrote:
> > 
> > * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > 
> > > > ? It would be very obvious at a glance what it does.
> > > 
> > > This fits in the generic "I have a .config and I want to enable an 
> > > additional option" functionality:
> > > 
> > > make oldconfig CONFIG_KVMTOOL_TEST_ENABLE=y
> > > 
> > > Don't we already have that support? I seem to remember it flying 
> > > by. Or was it just a proposal that never got implemented?
> > 
> > Well, it would be nice to have something (much) shorter and more 
> > obvious, as we really expect to use this frequently.
> > 
> > Maybe:
> > 
> >   make oldconfig kvm
> 
> Maybe something more obvious?:
> make modconfig kvm
> or
> make modconfig=kvm

Well, i run distinctly non-modular kernels so modconfig would not be 
particularly good. Also, many of the features enabled are non-modular 
core kernel features to begin with.

But i don't particularly care about how it's named, as long as 
there's a sane and obvious shortcut for it.

Thanks,

	Ingo
