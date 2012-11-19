Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2KSKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:36:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KSKge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:36:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1353302917-13995-47-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-47-git-send-email-josh@joshtriplett.org> <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/58] x86: arch/x86/kernel/irqinit.c: Add prototype for init_IRQ
Date: Mon, 19 Nov 2012 10:36:17 +0000
Message-ID: <22709.1353321377@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> wrote:

> arch/x86/kernel/irqinit.c defines an __init function init_IRQ, called
> from init/main.c.  No header file prototypes init_IRQ, because
> init/main.c tends to directly define prototypes for init functions it
> calls, rather than including appropriate headers.  So, add a prototype
> of init_IRQ to arch/x86/kernel/irqinit.c right above the definition, to
> satisfy gcc (-Wmissing-prototypes) and Sparse (-Wdecl).

Rather, you should put a declaration for it in a header file.

David
