Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab1DKIph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:45:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:34892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1DKIpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:45:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,338,1299484800"; 
   d="scan'208";a="416989600"
Date: Mon, 11 Apr 2011 10:45:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH v1] mfd: Fetch cell pointer from
 platform_device->mfd_cell
Message-ID: <20110411084532.GA2632@sortiz-mobl>
References: <20110408004007.GC3923@sortiz-mobl>
 <20110407193855.1e9182bb@debxo>
 <20110408231108.GD30969@sortiz-mobl>
 <20110409021654.GA4408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409021654.GA4408@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 07:16:54PM -0700, Greg KH wrote:
> On Sat, Apr 09, 2011 at 01:11:09AM +0200, Samuel Ortiz wrote:
> > 
> > In order for MFD drivers to fetch their cell pointer but also their
> > platform data one, an mfd cell pointer is added to the platform_device
> > structure.
> > That allows all MFD sub devices drivers to be MFD agnostic, unless
> > they really need to access their MFD cell data. Most of them don't,
> > especially the ones for IPs used by both MFD and non MFD SoCs.
> > 
> > Cc: Greg KH <gregkh@suse.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Thanks.

 
> I'm guesing this will go through someone elses tree than mine?
Yes, I'll push it through my MFD tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
