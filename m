Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab2GEXVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:21:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37179 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323Ab2GEXVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:21:53 -0400
Date: Thu, 5 Jul 2012 19:21:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
Message-ID: <20120705232136.GD15685@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	w@1wt.eu, ewust@umich.edu, zakir@umich.edu, greg@kroah.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@kernel.org
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu>
 <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx>
 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org>
 <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
 <1341527482.4020.1355.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341527482.4020.1355.camel@calx>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 05:31:22PM -0500, Matt Mackall wrote:
> On systems with a timer interrupt and a sched_clock() that's
> asynchronous to it, this actually loses a great source of entropy for
> headless systems. Also: extra branch in fast path.
> 
> It's better to mix and not credit than to not mix at all. Instead just
> check the fast count against HZ before the credit.

I'm not sure what you mean by this?

					- Ted
