Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab2DKPZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:25:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41642 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760562Ab2DKPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:25:32 -0400
Date: Wed, 11 Apr 2012 08:25:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
Message-ID: <20120411152528.GA27947@kroah.com>
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
 <op.wa9go4093l0zgt@mpn-glaptop>
 <20120411094112.GK12064@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411094112.GK12064@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:41:13PM +0300, Felipe Balbi wrote:
> On Fri, Mar 16, 2012 at 12:25:42PM +0100, Michal Nazarewicz wrote:
> > From: Michal Nazarewicz <mina86@mina86.com>
> > 
> > There are no in-tree fsg_add() users and it has been deprecated
> > since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
> > out-of-tree users had more then enough time to convert.  Removing.
> > ---
> 
> applied, thanks. Also added your SOB, next time be more careful.

Um, wait, you can't just "add" a SOB, that's not allowed at all, sorry.

Michal, do you sign-off on this patch?  If so, please do so.

greg k-h
