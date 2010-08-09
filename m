Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0HIH0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:26:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49507 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064Ab0HIH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:26:29 -0400
Date: Mon, 9 Aug 2010 09:26:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        tytso@mit.edu, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take two
Message-ID: <20100809072618.GB1586@ucw.cz>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I should have asked this earlier...  What exactly are the apps'
> >compatibility constraints?  Source-level APIs?  Byte-code class-library
> >invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
> >words, syscall)?
> 
> For Java/Dalvik apps, the wakelock API is pertty high level -- it
> talks to a service via RPC (Binder) that actually interacts with the
> kernel.  Changing the basic kernel<->userspace interface (within

Strange. Arve claimed that open/close is too slow, and few
microseconds faster ioctl is needed, and now we learn it actually uses
RPC.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
