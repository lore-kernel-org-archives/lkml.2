Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1DICQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 22:16:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1DICQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 22:16:25 -0400
Date: Fri, 8 Apr 2011 19:16:54 -0700
From: Greg KH <gregkh@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH v1] mfd: Fetch cell pointer from platform_device->mfd_cell
Message-ID: <20110409021654.GA4408@suse.de>
References: <20110408004007.GC3923@sortiz-mobl>
 <20110407193855.1e9182bb@debxo>
 <20110408231108.GD30969@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408231108.GD30969@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 01:11:09AM +0200, Samuel Ortiz wrote:
> 
> In order for MFD drivers to fetch their cell pointer but also their
> platform data one, an mfd cell pointer is added to the platform_device
> structure.
> That allows all MFD sub devices drivers to be MFD agnostic, unless
> they really need to access their MFD cell data. Most of them don't,
> especially the ones for IPs used by both MFD and non MFD SoCs.
> 
> Cc: Greg KH <gregkh@suse.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

I'm guesing this will go through someone elses tree than mine?

thanks,

greg k-h
