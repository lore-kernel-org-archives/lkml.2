Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0F3Gyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:54:47 -0400
Received: from smtp-out-152.synserver.de ([212.40.180.152]:1052 "HELO
	smtp-out-152.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752240Ab0F3Gyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:54:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 4034
Date: Wed, 30 Jun 2010 08:54:40 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes + agp + one fb patch
Message-ID: <20100630065440.GA1736@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
> 
> Hi Linus,
> 
> one fb layer fix in a flag I introduced,
> 
> the rest are drm fixes:
> radeon fixes: the larger ones in the command stream checker for older cards,
> which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
> along with some updates to the evergreen command stream checker introduced in -rc1.
> 
> agp: fix issue with warning on memory allocation + fallback to vmalloc.
> ttm: fix regression introduced in -rc1 in memory allocation paths.
> 
> The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
> 
>   Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
> 

I've tested these patches and they break my setup (RS780). On reboot, the
monitor goes straight to powersaving mode and no framebuffer is shown.

-- 
Markus
