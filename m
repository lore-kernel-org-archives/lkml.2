Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1CZEgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 00:36:19 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:57840 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1CZEgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 00:36:18 -0400
Date: Sat, 26 Mar 2011 00:35:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
In-reply-to: <201103252333.23880.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1103260021410.28928@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <alpine.LFD.2.02.1103241929450.16085@x980> <20110325113048.GC29521@elte.hu>
 <201103252333.23880.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  > > Beyond the lack of a upstream-visible feature-removal-schedule entry, we 
> >  > > still have an Arcnet driver which hardware was obsoleted by Ethernet in the 
> >  > > late 80s, and we still have i486 support and those are *much* older than 
> >  > > APM.

> > So how does your reasoning not apply to those drivers? There's several which 
> > are older than APM support.

If we follow-through with the proposed cpuidle changes,
then we'll have to cut APM code.   The problem isn't cutting
the code, it is testing it.  I do have a couple of 15-year old
laptops which include APM support.  However, with ACPI disabled
to enable APM, they don't even boot the upstream kernel today.

> > We had this really big battle about x86/Voyager two years ago, which x86 
> > subarchitecture literally had just a single user left, and the code was more 
> > intrusive than APM. Even there after much flaming the eventual consensus was 
> > that we'd accept it back if it was done cleanly, as part of the new-style 
> > x86_platform code.
> > 
> > Given that APM fits into the current PM frameworks there's no such problem here 
> > that i can see.

Somebody was pushing for Voyager support in the kernel
and was energetic about maintaining it.

cheers,
-Len

