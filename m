Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2JWHYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:24:21 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:43871 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2JWHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:24:18 -0400
Date: Tue, 23 Oct 2012 16:24:16 +0900
From: Norbert Preining <preining@logic.at>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121023072416.GB3695@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

(switched to freedesktop for dri-dvel)

> Does booting with i915.i915_enable_rc6=0 help?

Will try immediately.

> (Daniel, looks like an ironlake).

Sorry, I forgot that one ... how stupid>

>From XOrg.0.log:
...
[ 13535.841] (II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
[ 13535.841] (--) intel(0): Chipset: "Arrandale"
...

00:02.0 0300: 8086:0046 (rev 02) (prog-if 00 [VGA controller])
	Subsystem: 17aa:215a
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Capabilities: [a4] PCI Advanced Features
	Kernel driver in use: i915

00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)

Does that make any differences?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WIKE (vb.)
To rip a piece of sticky plaster off your skin as fast as possible in
the hope that it will (a) show how brave you are, and (b) not hurt.
			--- Douglas Adams, The Meaning of Liff
