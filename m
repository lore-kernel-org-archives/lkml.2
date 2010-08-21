Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0HUQIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 12:08:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51054 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0HUQIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 12:08:44 -0400
Date: Sat, 21 Aug 2010 18:08:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
Message-ID: <20100821160839.GA26375@merkur.ravnborg.org>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Out of interest, why is there no guard page for the VM_GROWSUP stack
> > case? Is it just that the memory layout on PA-RISC makes the stack grows
> > into the heap scenario impossible?
> 
> No, it's just that I can't find it in myself to care about PA-RISC, so
> I never wrote the code. I don't think anything else has a grows-up
> stack. And even if I were to write the code, I couldn't even test it.
> 
> It should be reasonably easy to do the VM_GROWSUP case too, but
> somebody with a PA-RISC would need to do it.

Tony Luck already provided a VM_GROWSUP version.

    See: http://lkml.org/lkml/2010/8/20/325

[It is signed off by Tony Luc - but I guess they know each other ;-) ]

	Sam
