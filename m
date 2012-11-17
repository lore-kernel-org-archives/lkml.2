Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab2KQVpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:45:30 -0500
Received: from audible.transient.net ([216.254.12.79]:51172 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752186Ab2KQVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:45:28 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2012 16:45:28 EST
Date: Sat, 17 Nov 2012 21:38:45 +0000
From: Jamie Heilman <jamie@audible.transient.net>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Airlie <airlied@linux.ie>, Kelly Doran <kel.p.doran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc5/rc6 regression] "drm/nvc0/disp: fix regression in
 vblank semaphore release" broke nouveau driver and mplayer
Message-ID: <20121117213845.GA4310@cucamonga.audible.transient.net>
Mail-Followup-To: Mikael Pettersson <mikpe@it.uu.se>,
	David Airlie <airlied@linux.ie>,
	Kelly Doran <kel.p.doran@gmail.com>, linux-kernel@vger.kernel.org
References: <20647.59126.898316.299551@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20647.59126.898316.299551@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> mplayer worked fine on my Dell Latitude E6510 (nVidia GT218 [NVS
> 3100M] graphics) up to and including kernel 3.7-rc4. However, with
> 3.7-rc5 or -rc6, any attempt to run mplayer just blanks the screen,
> shows some stray white pixels in the upper left corner, kills the X
> server, and spews the following errors from the kernel:
...
> 
> The error is 100% repeatable.

I see the same problem on my workstation with a G86 [Quadro NVS 290] (rev a1)
running Debian (sid) with:
xserver-xorg-core 2:1.12.4-3
libdrm-nouveau1a:amd64 2.4.33-3
xserver-xorg-video-nouveau 1:1.0.1-3
and mplayer2 2.0-600-g95e81df w/the xv video output driver

> git bisect identified the following culprit:
> 
> 11d92561c81be2f4a7af37f035e1af294b960abe is the first bad commit

I bisected to the same commit as well.


-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
