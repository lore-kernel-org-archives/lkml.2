Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0JZIYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:24:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3590 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab0JZIYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:24:02 -0400
Date: Tue, 26 Oct 2010 01:23:59 -0700 (PDT)
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] arch/x86/kernel/apic/io_apic.c: Typo fix WARNING
In-Reply-To: <20101026074812.GA9677@elte.hu>
Message-ID: <Pine.LNX.4.30.1010260114570.30853-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Ingo Molnar wrote:
> >  arch/x86/kernel/apic/io_apic.c |    2 +-
> > -		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
> > +		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
> >  		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
> While you are touching this please fix the other glaring problem this printk has.

There are 14 of these split lines formats in io_apic.c,
19 in apic and 1 in x2apic_uv_x.c.

There are also many apic_printk calls without KERN_<level>.

I prefer changing all of them at the same time rather
than 1 at a time.

