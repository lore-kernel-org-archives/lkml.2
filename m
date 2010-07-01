Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0GAX3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:29:53 -0400
Received: from kroah.org ([198.145.64.141]:37434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0GAX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:29:51 -0400
Date: Thu, 1 Jul 2010 16:17:29 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
       stable-review@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] 4 -stable kernel review cycles starting
Message-ID: <20100701231729.GA13598@kroah.com>
References: <20100701175100.GA2078@kroah.com>
 <201007012355.05531.florian@openwrt.org>
 <20100701221059.GA11663@kroah.com>
 <20100701153600.a0fc684e.rdunlap@xenotime.net>
 <20100701225129.GA12760@kroah.com>
 <20100701160901.887709e8.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701160901.887709e8.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 04:09:01PM -0700, Randy Dunlap wrote:
> On Thu, 1 Jul 2010 15:51:29 -0700 Greg KH wrote:
> > If you don't like this type of review cycle, what would you prefer?
> 
> I don't see a magic bullet answer here.  I think that it would help
> somewhat for the stable maintainer(s) to have only one -stable review
> cycle (new posting) per day, but someone may not like that either,
> since it would have the effect of delaying some stable kernel releases
> (not to mention muck up your workload).

Yeah, that would mess with the workload management a lot.  And I don't
see the benifit of doing a different release on different days.  Just
because they are different kernels, the same patches are usually being
applied to all of them, so they are very much alike usually.

thanks,

greg k-h
