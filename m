Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1L3VuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 16:50:25 -0500
Received: from science.horizon.com ([71.41.210.146]:37251 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744Ab1L3VuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 16:50:23 -0500
Date: 30 Dec 2011 16:50:20 -0500
Message-ID: <20111230215020.16178.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Does anyone collect old hardware for regression testing?
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple of old computers that hadn't been booted since 2005
(and they were ten years old THEN) and I'm wondering if anyone wants.

They'd been sitting in the closet for years, and I just fired them up
to clear off my personal data.

The used to have 2.6.12.2 kernels, but for amusement's sake more than
anything else I put a 3.2-rc7 kernel on one and am in process of doing
it on another.  (It's a bit intricate, because I have to build a new
kernel to run a new libc to install the latest userland to support the
new kernel features.)

Fortunately, the GCC 3.4 that's on there is still enough to build the
latest kernel.

One's an original first-generation 180 MHz Socket-8 Pentium Pro with
an Intel VS440FX motherboard (the non-USB version, unfortunately) and
128 MB of 72-pin EDO SIMMs.  It also has a Matrox MGA2064W Millenium
(first version!) video card and a couple of 3Com Vortex network cards.

(After it stopped being my desktop machine, it had a long life as a
household firewall and squid cache.)

Oh yes, and an ISA-bus CS4326 sound chip with ISAPNP support.


The other is a Pentium 166 (model 2 stepping 12, non-MMX, with the F00F
bug but not the fdiv bug) with an Intel Triton 1 430FX chipset, 96M of
RAM (but only 64M is cacheable!) another Matrix Millenium (they were
the hot thing back then), and a Linksys NC100 fast ethernet adapter.

Remember Socket 7 and VRM modules?

They both work fine, other than being 15 years out of date.  I can get
faster machines for $10 at the thrift store.


While hardly a real antique, I figure working machines with this hardware
are thinning out.  And I'd like to support Linux's tradition of not
dropping hardware support until it's pried from cold dead fingers.

I can maintain them myself as test boxes, but is there anyone who collects
old hardware who'd like them for regression testing?
