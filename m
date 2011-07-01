Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1GAL4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:56:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1GAL4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:56:44 -0400
Date: Fri, 1 Jul 2011 13:56:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110701115600.GK20990@elte.hu>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
 <1308875813-20122-5-git-send-email-wad@chromium.org>
 <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
 <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* James Morris <jmorris@namei.org> wrote:

> On Wed, 29 Jun 2011, Will Drewry wrote:
> 
> > Since it seems that there'll be consumers (openssh, vsftpd, 
> > kvm/qemu, chromium, chromium os) and feedback quieted down, what 
> > are the next steps to get this to a pull/no-pull decision points 
> > (or at least some Ack's or Nack's)?  I know this patch series 
> > crosses a number of maintainers, and I never know exactly what's 
> > next when the feedback slows down.
> 
> Are there any outstanding objections to this approach?  How do the 
> tracing folk feel about it?

I think i outlined my objections a couple of times and haven't seen 
them addressed.

Thanks,

	Ingo
