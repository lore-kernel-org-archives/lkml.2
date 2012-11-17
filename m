Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2KQWDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:03:11 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43037 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2KQWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:03:10 -0500
Date: Sat, 17 Nov 2012 23:03:42 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Airlie <airlied@linux.ie>, Kelly Doran <kel.p.doran@gmail.com>,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [3.7-rc5/rc6 regression] "drm/nvc0/disp: fix regression in
 vblank semaphore release" broke nouveau driver and mplayer
Message-ID: <20121117220342.GB23587@joi.lan>
References: <20647.59126.898316.299551@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20647.59126.898316.299551@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 08:35:18PM +0100, Mikael Pettersson wrote:
> mplayer worked fine on my Dell Latitude E6510 (nVidia GT218 [NVS 3100M] graphics)
> up to and including kernel 3.7-rc4. However, with 3.7-rc5 or -rc6, any attempt to
> run mplayer just blanks the screen, shows some stray white pixels in the upper left
> corner, kills the X server, and spews the following errors from the kernel:

Fix was already posted and should be merged soon.

http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=7a259e65569bd7593ad541c84982027969ec9c45
