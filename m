Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1KONOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:14:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1KONOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:14:16 -0500
Date: Tue, 15 Nov 2011 14:14:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
In-Reply-To: <1321362602.20271.192.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
References: <1321362602.20271.192.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, Paul Bolle wrote:

> Michal, Jiri,

[ adding LKML to CC ]

> 0) While, slowly, working through the accumulated Kconfig cruft I
> noticed quite a number of outdated (Kconfig) macros in (almost) all
> defconfig files. A few days ago I counted 161 outdated Kconfig macros,
> totaling 2189 lines in 426 defconfig files. Please see below for a draft
> commit log, with a sort-of-impressive stat. (A few of these macros are
> still used in the code. I already sent out messages to try to clean up
> that too.)
> 
> 1) They create false negatives while grepping for outdated stuff. At
> some point I decided to write a script to remove all of them.
> 
> 2) Is it worth the trouble to try to remove all that from the mainline
> tree? If it is, how would you propose I try to get something like this
> commit merged?

I am fine taking those through trivial.git and handling the fallout. The 
only ones I'd have objections to taking immediately are those which are 
actually still referenced somewhere in the code.
For those, either taking them through appropriate maintainers, or having 
their Acked-by would be required.

Thanks,

-- 
Jiri Kosina
SUSE Labs
