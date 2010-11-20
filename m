Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0KTQ3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:29:40 -0500
Received: from kroah.org ([198.145.64.141]:43338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0KTQ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:29:39 -0500
Date: Sat, 20 Nov 2010 08:27:26 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sep: Introduce sep driver
Message-ID: <20101120162726.GA29623@kroah.com>
References: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com> <20101120123911.356bc780@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120123911.356bc780@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 12:39:11PM +0000, Alan Cox wrote:
> 
> 
> > +/* rar handler */
> > +#ifndef CONFIG_MRST_RAR_HANDLER
> > +
> > +/* This stub header is for non Moorestown driver only */
> 
> What happened to the patches I sent you a while back that cleaned this
> one up ?

Wait, this isn't the cleaned up version?  Ick, should I just drop it and
wait for a working one instead?  Or Mark, are you going to fix this one
up for real this time?

thanks,

greg k-h
