Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0LIBvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:51:47 -0500
Received: from kroah.org ([198.145.64.141]:33665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0LIBvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:51:46 -0500
Date: Wed, 8 Dec 2010 17:52:04 -0800
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101209015204.GA8339@kroah.com>
References: <233716.61101.qm@web31813.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <233716.61101.qm@web31813.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 04:16:06PM -0800, Luben Tuikov wrote:
> --- On Mon, 12/6/10, Greg KH <greg@kroah.com> wrote:
> >
> > We already have this support in the kernel tree,
> 
> Greg, this isn't an effort for "linux kernel code turf".  This is a
> well-implemented driver according to the respective specifications
> (SAM, SPC, USB 2/3). It reflects correct implementation, naming, etc.
> It shows understanding of the abstraction layers and underlying
> technology. It's what you'd want to have in /YOUR/ kernel.

What I don't want in _anyones_ kernel is multiple drivers wanting to
attach to the same device.

> > why do you want and need another driver that does the same exact thing?
> 
> Nothing can be further from the truth. The current uas.c driver
> doesn't do the "exact same thing", far from it.
> 
> You responded 4 minutes after my post. Did you have to time to verify
> that the driver I posted does "the exact same thing" as the one in the
> kernel?

By "same thing" I mean "binds to the same device."

I have lived through the hell of this in the past and I will not let
that happen again, sorry.

> 
> "The exact same thing", let's see:

<snip>

I'm not saying that the in-kernel driver is perfect at all, and it's
author is getting annoying by refusing to answer my emails, but still,
please work with him to get the in-kernel driver to work up to your
needs.

If you have problems with the maintainer, please let me know and I'll
see what I can do.

But again, this driver is not acceptable as-is, sorry.

thanks,

greg k-h
