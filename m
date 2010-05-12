Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0ELN3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:29:19 -0400
Received: from nox2.protox.org ([95.130.11.66]:55741 "EHLO protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0ELN3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:29:17 -0400
Date: Wed, 12 May 2010 15:29:16 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Airlie <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       David@barney.localdomain
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Message-ID: <20100512132916.GD2790@barney.localdomain>
References: <11758_1273660249_4BEA8359_11758_1675_1_201005121121.49135.tvrtko.ursulin@sophos.com>
 <201005121138.05254.tvrtko.ursulin@sophos.com>
 <201005121150.42462.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005121150.42462.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:50:41AM +0100, Tvrtko Ursulin wrote:
> On Wednesday 12 May 2010 11:38:05 Tvrtko Ursulin wrote:
> 
> [snip]
> > I think it is DRM (radeon) related, leak stopped when I closed all X
> >  programs. I am compiling 2.6.33.3 right now and will soon reboot into it.
> 
> Leak is still present in 2.6.33.3 - the more GUI activity the more it leaks.
> So the ~512 objects per second was with xosview running, but moving windows or
> browsing through menus can leak a lot more (per second).
> 
> Is version of userspace drm library interesting? It is 2.4.20
> (libdrm-2.4.20-12.1.x86_64).
> 
> Tvrtko
> 

Do the number of object stay constant over longuer period of time
(30min, 1hour) ? If there was a leak i think we would have notice
it by now, some of my desktop are running 24h for several days with
radeon kms.

Cheers,
Jerome
