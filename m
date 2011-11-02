Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1KBIqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:46:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab1KBIqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:46:12 -0400
Date: Wed, 2 Nov 2011 09:41:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111102084124.GB18771@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <20111027193448.GA3514@merkur.ravnborg.org>
 <20111028070336.GF12995@elte.hu>
 <CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com>
 <20111028075432.GB8626@elte.hu>
 <20111028120856.GA29174@citd.de>
 <20111028122902.GA25323@elte.hu>
 <20111028130535.GA2752@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028130535.GA2752@citd.de>
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

> And AFAICS there currently is no "modconfig", only an 
> "allmodconfig" (and "localmodconfig")
> 
> With no letters dropped it would be less ambiguous. make 
> modifyconfig=kvm

Yeah. Note that it's more like an 'add' operation, not a modify 
operation, thus:

	make addconfig=kvm

or:

	make addconfig kvm

would be intuitive and would work well too.

Sam, Michal, which one would you prefer? The latter might have the 
advantage that it's additive, enabling future usages like:

	make addconfig kvm debug

as a quick shortcut to enable baseline KVM support and generic kernel 
debugging features, without having to twiddle with the menuconfig.

Hm? Would be nice to move on this issue, we've painted it to death 
already ;-)

Thanks,

	Ingo
