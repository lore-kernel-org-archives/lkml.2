Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2LQXPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:15:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33483 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2LQXPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:15:22 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
References: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
Date: Tue, 18 Dec 2012 00:15:20 +0100
Message-ID: <CAKMK7uHvqJbXqass9UTT-sUOxnggrUFouNA7019htq2445i_FQ@mail.gmail.com>
Subject: Re: i915: GPU hang
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:36 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Sorry, not sure what information is most appropriate here. GPU hangs from
> time to time on this laptop, typically when running firefox on
> graphics-intensive sites. Error log at the bottom. Distro is Debian 6.0.6
> (squeeze), lspci
>
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
>         Subsystem: Acer Incorporated [ALI] Device 011f
>         Flags: bus master, fast devsel, latency 0, IRQ 46
>         Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
>         Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         I/O ports at 1800 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [d0] Power Management version 3
>         Kernel driver in use: i915
>
> kernel version 3.5.2 (yes, I'll try to upgrade). Sometimes also the
> X-server freezes and restarts with no errors in dmesg. Is it a known
> problem?

Upgrading to 3.7 highly recommended, if just to get the recent pile of
gpu reset fixes - those should increase the chances that the reset
works and your system survives. Also worth testing is upgrading
userspace gfx driver components to the latest versions (mesa +
xf86-video-intel). If you still have gpu hangs with all that, please
file a bug report against DRM -> DRI/Intel and please attach the
i915_error_state from debugfs after your gpu hung).

Yours, Daniel


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
