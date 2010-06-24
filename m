Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab0FXEbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 00:31:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:50619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0FXEbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 00:31:46 -0400
Date: Wed, 23 Jun 2010 21:25:29 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb: Remove unnecessary return;s from void
 functions
Message-ID: <20100624042529.GA31700@suse.de>
References: <1276224993.1556.455.camel@Joe-Laptop.home>
 <1277335835.9699.0.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277335835.9699.0.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 04:30:35PM -0700, Joe Perches wrote:
> On Thu, 2010-06-10 at 19:56 -0700, Joe Perches wrote:
> > There are about 2500 void functions in drivers/usb
> > Only a few used return; at end of function.
> > 
> > Standardize them a bit.
> > 
> > Moved a statement down a line in drivers/usb/host/u132-hcd.c
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> ping?

It should go through the trivial tree please.

thanks,

greg k-h
