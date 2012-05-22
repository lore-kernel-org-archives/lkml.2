Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2EVCk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:40:26 -0400
Received: from ozlabs.org ([203.10.76.45]:43432 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2EVCkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:40:24 -0400
From: Michael Neuling <mikey@neuling.org>
To: David Rientjes <rientjes@google.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-reply-to: <2182.1337654352@neuling.org>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au> <328.1337652722@neuling.org> <alpine.DEB.2.00.1205211924390.13682@chino.kir.corp.google.com> <2182.1337654352@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Tue, 22 May 2012 12:39:12 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 22 May 2012 12:40:23 +1000
Message-ID: <2246.1337654423@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote:

> > > Trying David's patch just posted doesn't fix it.
> > > 
> > 
> > Hmm, what does CONFIG_DEBUG_VM say?
> 
> No set.

Sorry, should have read "Not set"

mikey
