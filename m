Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0IIXZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:25:38 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53877 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab0IIXZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:25:37 -0400
X-Greylist: delayed 2656 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 19:25:36 EDT
Date: Fri, 10 Sep 2010 07:41:17 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: after closing the lid and reopening it the screen remains blank
Message-ID: <20100909224117.GA30000@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

running: 2.6.36-rc3+ (from git) on Integrated Graphics Chipset: Intel(R) GM45
(Sony Vaio Z11)
Debian/unstable, so xserver 1.7.7, intel driver: 2.12.0

since some recent kernel I have the following problem: When closing the
lid on power, so the machine does not suspend, the backlight is properly
turned off.

But when I open the lid again the backlight goes on, but there is nothing
to see: No screensaver, no activity, nothing. Switching to Console in
blind didn't work either.

The machine is still responsible (Sysrq, but also CapsLock), and 
killing the X process with Ctrl-Alt-Backspace gets me back a working
X.

I am quite sure that it *was* working in former time, but cannot
pinpoint eaxactely when the problems started.

If you need any further information or testing, please let me know.
But it will take some time until I am back somewhere where I can
ssh into my machine (or try if I can ssh into).

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BELPER
A knob of someone else's chewing gum which you unexpectedly find your
hand resting on under a deck's top, under the passenger seat of your
car or on somebody's thigh under their skirt.
			--- Douglas Adams, The Meaning of Liff
