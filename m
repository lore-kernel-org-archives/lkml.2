Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0LANgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:36:51 -0500
Received: from ozlabs.org ([203.10.76.45]:49846 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab0LANgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:36:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Date: Thu, 2 Dec 2010 00:06:45 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: matthieu castet <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <davej@redhat.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <4CE2F914.9070106@free.fr> <201011301005.29532.rusty@rustcorp.com.au> <1291128383.27486.35.camel@gandalf.stny.rr.com>
In-Reply-To: <1291128383.27486.35.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012020006.46115.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 01:16:23 am Steven Rostedt wrote:
> On Tue, 2010-11-30 at 10:05 +1030, Rusty Russell wrote:
> > On Tue, 30 Nov 2010 04:45:42 am Steven Rostedt wrote:
> > > This patch breaks function tracer:
> > ...
> > > Here we set the text read only before we call the notifiers. The
> > > function tracer changes the calls to mcount into nops via a notifier
> > > call so this must be done after the module notifiers.
> > 
> > That seems fine.
> > 
> > I note that both before and after this patch we potentially execute code
> > in the module (via parse_args) before we set it ro & nx.  But fixing this
> > last bit of coverage is probably not worth the pain...
> 
> Rusty, can I take this as an "Acked-by"?

Yep... Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
