Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2KRLo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 06:44:29 -0500
Received: from smtp1.uu.se ([130.238.7.54]:43241 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2KRLo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 06:44:27 -0500
X-Spam-Flag: NO
X-Spam-Score: -3.835
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20648.51574.129686.811296@pilspetsen.it.uu.se>
Date: Sun, 18 Nov 2012 12:41:42 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, David Airlie <airlied@linux.ie>,
        Kelly Doran <kel.p.doran@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [3.7-rc5/rc6 regression] "drm/nvc0/disp: fix regression in
 vblank semaphore release" broke nouveau driver and mplayer
In-Reply-To: <20121117220342.GB23587@joi.lan>
References: <20647.59126.898316.299551@pilspetsen.it.uu.se>
	<20121117220342.GB23587@joi.lan>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz writes:
 > On Sat, Nov 17, 2012 at 08:35:18PM +0100, Mikael Pettersson wrote:
 > > mplayer worked fine on my Dell Latitude E6510 (nVidia GT218 [NVS 3100M] graphics)
 > > up to and including kernel 3.7-rc4. However, with 3.7-rc5 or -rc6, any attempt to
 > > run mplayer just blanks the screen, shows some stray white pixels in the upper left
 > > corner, kills the X server, and spews the following errors from the kernel:
 > 
 > Fix was already posted and should be merged soon.
 > 
 > http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=7a259e65569bd7593ad541c84982027969ec9c45

That patch fixes the bug I reported. Thanks.
