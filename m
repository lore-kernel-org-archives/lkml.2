Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab0HLMxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:53:24 -0400
Received: from THUNK.ORG ([69.25.196.29]:55117 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907Ab0HLMxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:53:21 -0400
Date: Thu, 12 Aug 2010 08:52:49 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812125248.GA2763@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
	tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
	James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
	galibert@pobox.com, dipankar@in.ibm.com
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
 <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 03:28:01PM +0300, Felipe Contreras wrote:
> 
> The question is why are we adding a user-space API that:
>  1) no user-space beside Android has expresses interest in implementing
>  2) is dubious whether the benefits are worth the pain for non-Android
> user-space
>  3) will become less and less attractive as dynamic PM gets closer to
> the sweet-spot, and then surpass it
>  4) Android can keep in a separate tree until it's clear in the linux
> community that it's useful (if it ever happens)

So, Felipe,

Do you believe you speak for all of LKML?

Are you willing to tell ZDNet and the Slashdot fanboys that it's OK
for Suspend blockers to live in a separate tree, and it's not a case
of OMG!  Google is forking the kernel?

If you could speak out a passionately on those forums as you have
here, that would be great.

						- Ted
