Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0J0Ocz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:32:55 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:33856 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab0J0Ocx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:32:53 -0400
Date: Wed, 27 Oct 2010 23:32:52 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: several problems with intel graphics since 2.6.36
Message-ID: <20101027143252.GA8676@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-IMAPbase: 1287824063 1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have the feeling that 2.6.36 has introduced many regressions
concerning Intel graphics card.

My problems, all of them new in 2.6.36, are:
- suspend is not stable anymore
  often the backlight comes back on, but the graphic state is not
  restored and the computer hangs hard, sysrq not working
  Sometimes not even the backlight is restored.

  OTOH, I just went back to 2.6.35 and went to 6 or 7 suspend/resume
  cycles with doing stuff inbetween, without any rattle or shake,
  smooth like silk.

- flickering of the display is quite common, and often quite strong,
  so flashes around like tearing an image for a short time.

- screen redraw problems: sometimes closing a window leaves vertical
  traces on the screen, on other windows or the gnome panel. This
  can be fixed by switching to the console and back, or forcing a
  complete redraw of the window by minimizing it (does not work with panel
  of course).

- (minor issue) after connecting an external monitor (video projector)
  the adjustment of the brightness is not working. Even if I unplug
  the external device brightness adjustment remains disabled.
  I have to start xrandr or some GUI for adjustment to get brightness
  adjustment back to work.
  (not sure if that is a regression)


hardware:
Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller rev 7
Sony VAIO Z11-VGN

Computing environment: 
Debian/unstable
X server 1.7.7
intel_drv version: 2.12.0


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SHRIVENHAM (n.)
One of Germaine Greer's used-up lovers.
			--- Douglas Adams, The Meaning of Liff
