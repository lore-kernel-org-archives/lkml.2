Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2JPMyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab2JPMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:54:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJL_ektJgQayiTPAkxxaT3TZLuUCjo2UsFuhMuxCsp-DFVqjFQ@mail.gmail.com>
References: <CAJL_ektJgQayiTPAkxxaT3TZLuUCjo2UsFuhMuxCsp-DFVqjFQ@mail.gmail.com> <1349998076-15495-1-git-send-email-dhsharp@google.com> <1349998076-15495-2-git-send-email-dhsharp@google.com> <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: dhowells@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
Date: Tue, 16 Oct 2012 13:53:51 +0100
Message-ID: <6469.1350392031@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sharp <dhsharp@google.com> wrote:

> > Please use the Kbuild infrastructure ("generic-y += ..." in
> > arch/*/include/asm/Kbuild)
> > instead of adding wrappers around the asm-generic version.
> 
> mips apparently recencly got rid of arch/mips/include/asm/Kbuild.

It didn't.  However, if you use patch to create your kernel tree, then patch
may have removed it.  If you're using GIT, it should still exist.  Try:

	git log -- arch/mips/include/asm/Kbuild 

> What should I do for mips?

Just create the file with a single "generic-y += ..." line in it.

David
