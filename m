Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0LYWnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 17:43:11 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:52047 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0LYWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 17:43:09 -0500
Date: Sat, 25 Dec 2010 17:42:59 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: recurring problem, booting to black screen with intel GPU
Message-ID: <alpine.DEB.2.00.1012251737030.4626@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  on my ubuntu laptop (gateway NV79), a 2.6.37-rc7+ kernel i just
built now boots to a black screen.  no text mode, no virtual consoles,
nothing.

  this is probably the best explanation:

http://www.oblurb.com/ubuntu-dell-latitude-e6510-intel-gpu-blank-screen.html

annoyingly, i'm currently running a 2.6.37-rc5+ hand-rolled kernel
that works fine, but this more recent kernel doesn't, and a kernel
*earlier* also doesn't work, so this issue seems to come and go.

  here's another extended conversation on the same topic:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/600453

here's the relevant output from lspci:

00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
        Subsystem: Acer Incorporated [ALI] Device 031c
        Flags: bus master, fast devsel, latency 0, IRQ 41
        Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at 3050 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915

if i use "nomodeset", i can boot to the command line and no further.
i'm open to suggestions.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
