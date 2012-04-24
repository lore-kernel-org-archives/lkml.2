Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2DXNgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:36:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43214 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2DXNgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:36:35 -0400
MIME-Version: 1.0
X-Originating-IP: [14.97.104.208]
Date: Tue, 24 Apr 2012 19:06:34 +0530
Message-ID: <CAAhSdy12KufzNtrf6wYY7rK0LZMPC-_-4N+p4JwJsV5MB6HTDg@mail.gmail.com>
Subject: [ANNOUNCE] [OFFTOPIC] Xvisor ARM with and/or without virtualization extensions
From: Anup Patel <anup@brainfault.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        android-virt@lists.cs.columbia.edu, beagleboard@googlegroups.com,
        xen-arm@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xvisor (eXtensible Versatile hypervISOR) is an open source bare-metal
monolithic hypervisor, which aims towards providing virtualization solution,
which is light-weight, portable, and flexible with small memory foot print
and less overhead. It is distributed under GNU Public License (GPLv2).

Xvisor has most of the features expected from a modern full-fledged hypervisor,
such as:
    - Tree based configuration
    - Tickless and high resolution timekeeping
    - Wall-clock for tracking real-time
    - Threading framework
    - Host device driver framework
    - CPU virtualization
    - Address space virtualization
    - IO device emulation framework
    - Pass through hardware access
    - Dynamic guest creation/destruction
    - Serial port virtualization
    - Management terminal

The ARM port of Xvisor (or Xvisor ARM) supports a wide range of ARM processors
namely:
    - ARM9 (Boards: VersatilePB)
    - Cortex-A8 (Boards: Realview-PB-A8)
    - OMAP3 (Boards: BeagleBoard-xM)
    - Cortex-A9 (UP) (Boards: Vexpress-A9)
    - Cortex-A15 (UP) Without VE (Boards: Vexpress-A15)
    - Cortex-A15 (UP) With VE (Boards: Vexpress-A15)

For all supported ARM processors Xvisor ARM is able to boot multiple unmodified
Linux-3.0.4 guest with a fairly interactive and smooth Busybox 0.19.2 console.

On real hardware specifically BeagleBoard-xM (OMAP3 @ 600 MHz) we get near
native CPU performance (i.e. Native Linux 3.0.4 gives 1120 DMIPS whereas Linux
3.0.4 running as guest on Xvisor ARM gives 960 DMIPS)

Please try out our Xivsor Cortex-A15 demo on ARM Fast Models 7.0 and/or
Linaro QEMU (2.02 or higher). To download the demo tarball visit:
https://docs.google.com/open?id=0B0ABS_s60oP_WjNQQ0QtUzNmdmc

Xvisor is currently hosted on Github, to clone or download source code please
visit following links:
Wiki: https://github.com/xvisor/xvisor/wiki
Mainline Repository: https://github.com/xvisor/xvisor
Stagging Repository: https://github.com/avpatel/xvisor-next

Our developer mailing list is xvisor-devel[at]googlegroups[
dot]com, please feel free to post your queries or join our development
mailing list.
