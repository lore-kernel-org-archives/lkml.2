Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab1ESCmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:42:11 -0400
Received: from relais.videotron.ca ([24.201.245.36]:26798 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab1ESCmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:42:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 18 May 2011 22:42:09 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Barry Song <21cnbao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
In-reply-to: <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1105182234130.14430@xanadu.home>
References: <201105181047.17309.arnd@arndb.de>
 <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Barry Song wrote:

> does it mean if we want to add a new SoC plat/mach, we will send
> patches againest this tree?

Yes.  Or against latest mainline tree from Linus.

> will this tree merge into rmk's tree? then rmk's tree will only manage
> arm common codes?

Something like that.  The exact details will be fleshed out as we go. 
The idea is to give a round of review from a higher point of view to 
make sure no opportunities for code reuse is missed, etc.  The mechanics 
of how this code transitions from this tree into mainline during the 
merge window is secondary.


Nicolas
