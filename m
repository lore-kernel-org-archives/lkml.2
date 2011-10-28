Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1J1MJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:09:11 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:41431 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1J1MJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:09:10 -0400
Date: Fri, 28 Oct 2011 14:08:56 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111028120856.GA29174@citd.de>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <20111027193448.GA3514@merkur.ravnborg.org>
 <20111028070336.GF12995@elte.hu>
 <CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com>
 <20111028075432.GB8626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028075432.GB8626@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2011 09:54, Ingo Molnar wrote:
> 
> * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > > ? It would be very obvious at a glance what it does.
> > 
> > This fits in the generic "I have a .config and I want to enable an 
> > additional option" functionality:
> > 
> > make oldconfig CONFIG_KVMTOOL_TEST_ENABLE=y
> > 
> > Don't we already have that support? I seem to remember it flying 
> > by. Or was it just a proposal that never got implemented?
> 
> Well, it would be nice to have something (much) shorter and more 
> obvious, as we really expect to use this frequently.
> 
> Maybe:
> 
>   make oldconfig kvm

Maybe something more obvious?:
make modconfig kvm
or
make modconfig=kvm

That would also fit nicely for future addition.



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

