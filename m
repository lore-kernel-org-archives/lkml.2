Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2GFSiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:38:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51338 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337Ab2GFSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:38:02 -0400
X-Sasl-enc: pX1erBUgC2a95/rhfTxb9Kf1/FuhEouAxR7nAF6KzJy9 1341599880
Date: Fri, 6 Jul 2012 11:37:59 -0700
From: Greg KH <greg@kroah.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/tile: provide kernel support for the tilegx USB
 shim
Message-ID: <20120706183759.GA13488@kroah.com>
References: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
 <20120706173635.GB2373@kroah.com>
 <4FF72794.7010009@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF72794.7010009@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 01:59:48PM -0400, Chris Metcalf wrote:
> On 7/6/2012 1:36 PM, Greg KH wrote:
> > On Wed, May 09, 2012 at 12:25:02PM -0400, Chris Metcalf wrote:
> >> This change adds support for accessing the USB shim from within the
> >> kernel.  Note that this change by itself does not allow the kernel
> >> to act as a host or as a device; it merely exposes the built-in on-chip
> >> hardware to the kernel.
> > What do you mean by this?  This is needed for the other patches, right?
> > If so, I'm guessing they are going through the tile tree?  That's fine
> > with me.
> 
> Correct; this piece just adds the infrastructure that lets you then layer
> the standard USB host code on top.  I'm assuming I'll push both the tilegx
> USB infrastructure, and the drivers/usb/host stuff, through the tile tree. 
> Or, I can push just the low-level stuff through the tile tree and let the
> USB host stuff go through the usb tree.

I have no objection for you to take all of it through your tree.

thanks,

greg k-h
