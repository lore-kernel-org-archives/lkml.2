Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2KZXYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:24:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:38645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238Ab2KZXX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:23:59 -0500
Date: Mon, 26 Nov 2012 15:23:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: pv-drivers@vmware.com, George Zhang <georgezhang@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121126232357.GA21664@kroah.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121126223754.GA28681@kroah.com>
 <1975718.7UL0qBEfzR@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1975718.7UL0qBEfzR@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 03:01:04PM -0800, Dmitry Torokhov wrote:
> On Monday, November 26, 2012 02:37:54 PM Greg KH wrote:
> > On Wed, Nov 21, 2012 at 12:31:04PM -0800, George Zhang wrote:
> > > * * *
> > > This series of VMCI linux upstreaming patches include latest udpate from
> > > VMware.
> > > 
> > > Summary of changes:
> > > 	- Sparse clean.
> > > 	- Checkpatch clean with one exception, a "complex macro" in
> > > 	
> > > 	  which we can't add parentheses.
> > > 	
> > > 	- Remove all runtime assertions.
> > > 	- Fix device name, so that existing user clients work.
> > > 	- Fix VMCI handle lookup.
> > 
> > Given that you failed to answer the questions I asked the last time you
> > posted this series, and you did not make any of the changes I asked for,
> > I can't accept this (nor should you expect me to.)
> > 
> > And people wonder why reviewers get so grumpy...
> > 
> > My trees are now closed for the 3.8 merge window, so feel free to try
> > again after 3.8-rc1 is out, and you have answered, and addressed, the
> > questions and comments I made.
> 
> Greg, there were 3 specific complaints from you:
> 
> 1. "Given that this is a static function, there's no need for these
> "asserts", right?  Please send a follow-on patch removing all BUG_ON()
> calls from these files, it's not acceptable to crash a user's box from
> a driver that is handling parameters you are feeding it."
> 
> 2. "You obviously didn't run checkpatch on this file"
> 
> 3. "This line causes sparse to complain.  The odds that userspace knows
> what gcc is using for "bool" is pretty low."
> 
> Given the fact that the series addresses all 3 I fail to understand why
> you would be grumpy.

You are ignoring my response to patch 12/12 for some reason (which
repeated a bunch of the questions I had with that patch the last time it
was posted.)  That is what I am referring to here.  None of those
questions were addressed.

Also, how was I to know that those 3 comments above were addressed?
When someone posts questions and comments, please respond to those
comments.  Don't just not respond at all and post the whole series 2
weeks later with things changed and a vague comment of "summary of
changes" in the 00 message.  Otherwise I will assume that you never even
saw my post.

In other words, if someone takes the time to review and post comments,
the least you can do is acknowledge those comments, right?

thanks,

greg k-h
