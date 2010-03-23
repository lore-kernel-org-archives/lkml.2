Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0CWEjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:39:53 -0400
Received: from tenax.loup.net ([209.169.16.66]:46838 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0CWEjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:39:52 -0400
Date: Mon, 22 Mar 2010 22:25:25 -0600
Message-Id: <201003230425.o2N4PP5q009109@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: linux-kernel@vger.kernel.org
Subject: Regression: my systems can no longer boot from an ide hard drive
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three identical known good opteron systems can no longer boot freshly
installed distros from an ide hard drive.  The systems have one ide
drive and eight sata drives.  If distro is installed to ide drive,
Ubuntu 9.10 server moves cursor down the screen twice, then hangs
while Fedora 12 grub loads but then claims it can't find root to mount
and it and hangs 'forever'.  Numerous distros have all booted fine
before 2.6.25... I don't know where it went wrong between 25 and 31.

This is despite partitioning with and without lvm, despite making sure
kernel/boot loader are in partition in first 2 gigs of ide drive.

Both distros boot just fine on each system when os is installed on a
sata drive so this isn't a hardware defect.

Distro that boots fine from ide:
Linux opt1 2.6.25-14.fc9.x86_64 #1 SMP Thu May 1 06:06:21 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

Distros that no longer boot via ide drive:
Linux opt2 2.6.31-14-server #48-Ubuntu SMP Fri Oct 16 15:07:34 UTC 2009 x86_64 GNU/Linux
Linux opt3 2.6.31.5-127.fc12.x86_64 #1 SMP Sat Nov 7 21:11:14 EST 2009 x86_64 x86_64 x86_64 GNU/Linux

Maybe this can be worked around with some options to grub or
kernel... if so, shouldn't distros detect that ide drives are being
set up and configure the boot loader properly?  It would be very hard
for newbie to figure this one out.

Has anyone else seen this, or am I the only one who boots from ide
when a sata drive is present? :-)

- Mike
