Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1AHEmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 23:42:11 -0500
Received: from kroah.org ([198.145.64.141]:57909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1AHEmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 23:42:09 -0500
Date: Fri, 7 Jan 2011 20:42:43 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Google firmware drivers in staging?
Message-ID: <20110108044243.GA8120@kroah.com>
References: <AANLkTin215LOZDs_BL6r9Aa_fX60iwyEZQ-FzbcEhXCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin215LOZDs_BL6r9Aa_fX60iwyEZQ-FzbcEhXCQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 05:34:00PM -0800, Mike Waychison wrote:
> Hi Greg, Linus,
> 
> I'm going through our core dependencies for changes to the kernel that
> we use in house.  FWIW, these "core" dependencies are essentially
> required for our userland stack to function properly in our cluster
> environment.  My goal is to make it seamless for other Google
> engineers to use otherwise mainline kernels on our machines, enabling
> them to develop more of their code against mainline.
> 
> Anyhow, rummaging down the list of stuff that we consider "core", I've
> come across a couple firmware specific drivers.  These drivers are
> specific to our machines, and would likely never apply to anyone
> else's hardware.  That said, they aren't very complicated (they are
> mostly isolated) and generally just help us plumb information between
> userland and the firmware itself (like system event log data).
> 
> I'd like to get rid of these drivers as a delta between mainline and
> our in-house trees.  Note that I can't really change anything on the
> firmware side as those ABIs are sorta written in stone for all intents
> and purposes, but I'd be happy to adapt the userland-exposed sides of
> the drivers if needed.
> 
> I'd like to release these guys publicly if there is any hope that they
> can wind up in the official tree.   What are your thoughts on putting
> them through the staging tree?

I have no objection to merging code that is only used by a single
machine.  Heck, we have a whole subarchicture for only 2 machines in the
whole world :)

Anyway, sure, send them to me for staging, if you feel they still need
some work to be cleaned up before they can go to the main portion of the
tree.  If you feel they are "ready", then send them for submission for
the real part of the kernel (drivers/firmware/ I'm guessing?)  I'll
queue them up as well for the next big merge window for them.

thanks,

greg k-h
