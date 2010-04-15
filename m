Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0DOGUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:20:33 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34148 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0DOGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:20:31 -0400
Date: Thu, 15 Apr 2010 08:20:23 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 2/4] isl29020: ambient light sensor
Message-ID: <20100415062023.GG30801@buzzloop.caiaq.de>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
 <20100414125147.23181.5817.stgit@localhost.localdomain>
 <20100414224542.GX30807@buzzloop.caiaq.de>
 <20100414233554.3f020155@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414233554.3f020155@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:35:54PM +0100, Alan Cox wrote:
> > Would it be possible to make the existing driver for the ISL29003
> > support the ISL29020 as well?
> 
> I dug the manuals out for these to take a look - the answer is they are
> quite different chips. 

Hmm, sad :(

However, the driver should be applied to the ALS tree after all, unless
Jonathan plans to drop the whole thing, which I doubt.

Thanks,
Daniel
