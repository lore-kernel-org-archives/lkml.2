Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2L3Ux5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 15:53:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2L3Uxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 15:53:54 -0500
Date: Sun, 30 Dec 2012 21:53:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: Re: i915: GPU hang
In-Reply-To: <CAKMK7uHvqJbXqass9UTT-sUOxnggrUFouNA7019htq2445i_FQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1212302141120.19832@axis700.grange>
References: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
 <CAKMK7uHvqJbXqass9UTT-sUOxnggrUFouNA7019htq2445i_FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jTw2uRM1NeO+YBCQXaHOt6JMczTzorK3wyApmzD9gUL
 Ya/ZaLOL283JWN3zETBHcvylm3EBLyY/EQk3gMsnTwdOBYVadX
 xHCAAG40AfYUui6Nn3+07dwj8SSBIvz82N6QJiaXDiDQtAWKFw
 Yrv3zs3FYiJ5FuZRGV/lKMs0SaTf61cn4TnvuLD6KA73wdnLkW
 NfbPZLLciKtcB01TbwPKuGlVardv0HPL1h1G6QvjUPKURTA3WF
 oFk+PL0MJM4w2o5gH0R7cqnUpr/yHuC1GO3U4loNe1OyZa1UbI
 9n5VyyKzoeLRaM+V2GGvzu3m3lJBw0VKsKG2Oo94aKVP0ijqz8
 sDV0/6S9a63mmfesUOc9leSAlaO8mvWOfobDI44Z4HGujQDAfa
 XaYdUlGhawZww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel

Sorry for a late reply.

On Tue, 18 Dec 2012, Daniel Vetter wrote:

> On Mon, Dec 17, 2012 at 11:36 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Sorry, not sure what information is most appropriate here. GPU hangs from
> > time to time on this laptop, typically when running firefox on
> > graphics-intensive sites. Error log at the bottom. Distro is Debian 6.0.6
> > (squeeze), lspci
> >
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> > Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
> >         Subsystem: Acer Incorporated [ALI] Device 011f
> >         Flags: bus master, fast devsel, latency 0, IRQ 46
> >         Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
> >         Memory at d0000000 (64-bit, prefetchable) [size=256M]
> >         I/O ports at 1800 [size=8]
> >         Expansion ROM at <unassigned> [disabled]
> >         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> >         Capabilities: [d0] Power Management version 3
> >         Kernel driver in use: i915
> >
> > kernel version 3.5.2 (yes, I'll try to upgrade). Sometimes also the
> > X-server freezes and restarts with no errors in dmesg. Is it a known
> > problem?
> 
> Upgrading to 3.7 highly recommended, if just to get the recent pile of
> gpu reset fixes - those should increase the chances that the reset
> works and your system survives.

Did that and it did work for a while, longer than the average with 3.5. I 
was already about to write a success report, but then it hung again 
yesterday. I'm not using this laptop very intensively, so, it is hard to 
collect statistics.

> Also worth testing is upgrading
> userspace gfx driver components to the latest versions (mesa +
> xf86-video-intel).

Not sure I'll be bothered - recompiling user-space is too much of a hastle 
;-) Maybe I'll just upgrade my distro altogether. Thanks for the tips 
anyway!

> If you still have gpu hangs with all that, please
> file a bug report against DRM -> DRI/Intel and please attach the
> i915_error_state from debugfs after your gpu hung).
> 
> Yours, Daniel

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
