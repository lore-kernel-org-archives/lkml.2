Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0FNVqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:46:51 -0400
Received: from THUNK.ORG ([69.25.196.29]:51920 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0FNVqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:46:49 -0400
Date: Mon, 14 Jun 2010 17:46:46 -0400
From: tytso@mit.edu
To: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Message-ID: <20100614214646.GF6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
 <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
 <20100613194949.GC8055@thunk.org>
 <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
 <20100614184244.GA11480@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614184244.GA11480@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:42:44PM -0400, Nick Bowler wrote:
> 
> This sounds exactly like the issue I've been seeing on a T500 laptop, as
> well (GM45 board).  The slowdowns render the system essentially
> unusable, as it can spend a loooong time just moving the mouse cursor a
> few pixels on the screen.  During this time, nothing else on the display
> is updating (glxgears drops to 0fps).  Things generally seem to be
> working fine if I am not moving the mouse, or if I'm not running X.

I saw exactly the same behaviour when using the Ubuntu Karmic
userspace.  Basically, using a 2.6.35-rc2 (+ vt memory corrupter fix)
kernel, the system was essentially unusable.  Interestingly, the
problem went away (with the same kernel) once I updated to Ubuntu
Lucid.  I was going to mention that so that hopefully someone with far
more X.org-fu than I could figure out how much of this is a X server
bug, and how much of this was a kernel bug, but things worked just
*fine* with 2.6.34 kernel.

Occasionally it will happen that the mouse stops tracking, and then I
grumble and curse, and a few seconds later it resolves itself.  I
haven't had time to track it down; but the problem was breathtakingly
easy to reproduce with an Ubuntu Karmic userspace.  :-)

     		       	  	 		    - Ted
