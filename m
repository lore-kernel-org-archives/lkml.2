Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0D1X2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:28:47 -0400
Received: from kroah.org ([198.145.64.141]:57017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0D1X2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:28:46 -0400
Date: Wed, 28 Apr 2010 16:12:41 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sankar P <sankar.curiosity@gmail.com>, gregkh@suse.de, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: winbond: Cleanups
Message-ID: <20100428231241.GA28878@kroah.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <4BA613C7.5030600@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA613C7.5030600@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 02:40:39PM +0200, Pekka Enberg wrote:
> Sankar P wrote:
> >The following series of patches are cleanups on the winbond driver
> >under staging. Some typedefs are converted to structs and
> >an un-used enumeration and a typedef are removed.
> 
> Well, there's an identical patch series by me floating around
> waiting for Greg to apply them. But should Greg go with these, they
> look good to me except for the fixed point one for which we have a
> better patch also waiting to be applied.

I've applied the first 4 of these then.

thanks,

greg k-h
