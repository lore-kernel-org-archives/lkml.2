Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1I2LTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:19:32 -0400
Received: from science.horizon.com ([71.41.210.146]:49957 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751045Ab1I2LTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:19:30 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Sep 2011 07:19:30 EDT
Date: 29 Sep 2011 07:11:37 -0400
Message-ID: <20110929111137.31852.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Has anyone noticed text console breakage since 3.0?
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently running 3.1-rc7, and for a while, whenever I've been
running a text console, I've noticed odd dropouts and glitches.

It used to be mostly ANSI control sequences for fancy graphics.
welcome2l's splach screen would get some rows shifted left as
characters were skipped, and "aptitude -u" (which shows multiple
animated progresss bars) would suffer a lot.

But now it's getting to the point that just typing this e-mail
in black & white is experiencing multiple corruptions.
What's on my screen is "the poin hthat" and "black w white".
I expect turning off the "ruler" feature in vim which maintains
a cursor position display at the bottom of the screen will reduce
the problem, but I've seen problems at the shell prompt.

This is a quad-core Phenom processor, running a 64-bit kernel
on ECC memory.  The hardware has been stable for years.

The problem is specifically with a *text* console, not a frame buffer
console.  If nobody's sure, I can take a few hours and do a bisect
run, but it seems hard to believe I'm the only person seeing this.
