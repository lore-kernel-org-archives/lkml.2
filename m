Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1A1C6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:58:34 -0500
Received: from kroah.org ([198.145.64.141]:34031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab1A1C6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:58:32 -0500
Date: Thu, 27 Jan 2011 18:59:13 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110128025913.GD32284@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com>
 <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com>
 <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:58:46PM -0800, Mike Waychison wrote:
> > Not to
> > mention the fact that you really are just adding special syscalls to the
> > system here, which is another reason people hate them.
> 
> Well, personally I like ioctls and system calls.  They don't bloat the
> system with unneeded crud and abstractions that aren't very useful.
> So what if you can't easily interface with them from a bare shell.
> That's what userland utilities are for anyhow.

Ok, but you need to document exactly what your ioctl is doing, much like
you need to document any new system calls.  That is my point, there
wasn't documentation with these new functions describing what they did
and how to use them.

Please see Documentation/ABI/ for how to add this type of information.
Yes, that's primarily used to describe sysfs files, but there's no
reason it can't describe ioctls as well.

> > So, let me ask, what specifically are you wanting to import/export
> > to/from the kernel here?  Have you thought about other kernel/user apis
> > instead of ioctls?  What is forcing you to use ioctls?
> 
> I'm not sure if you are trying to suggest that there is a better way
> to solve these problems without actually saying so.  We could probably
> use a different interface, sure.

I can't tell what you are trying to do here to determine what the best
type of interface is.

thanks,

greg k-h
