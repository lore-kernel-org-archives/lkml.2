Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0KUR2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:28:24 -0500
Received: from kroah.org ([198.145.64.141]:59081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0KUR2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:28:23 -0500
Date: Sun, 21 Nov 2010 09:21:44 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sep: Introduce sep driver
Message-ID: <20101121172144.GA3703@kroah.com>
References: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com> <20101120123911.356bc780@lxorguk.ukuu.org.uk> <20101120162726.GA29623@kroah.com> <20101121140757.66681d35@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121140757.66681d35@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 02:07:57PM +0000, Alan Cox wrote:
> On Sat, 20 Nov 2010 08:27:26 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sat, Nov 20, 2010 at 12:39:11PM +0000, Alan Cox wrote:
> > > 
> > > 
> > > > +/* rar handler */
> > > > +#ifndef CONFIG_MRST_RAR_HANDLER
> > > > +
> > > > +/* This stub header is for non Moorestown driver only */
> > > 
> > > What happened to the patches I sent you a while back that cleaned this
> > > one up ?
> > 
> > Wait, this isn't the cleaned up version?  Ick, should I just drop it and
> > wait for a working one instead?  Or Mark, are you going to fix this one
> > up for real this time?
> 
> I sent Mark a set of follow on patches. Dunno if they got lost in part or
> not. No big deal as they applied on top of his previous set so can just
> be applied as a follow up to the merge.
> 
> So I'd rather you carried on merging them and we'll figure out which of
> the other bits need dropping on top.

Ok, it's in the tree now, but again, it has a ton of build warnings that
should be fixed before I start to get angry emails from Randy about it
:)

thanks,

greg k-h
