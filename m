Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2BFPkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:40:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57168 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2BFPkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:40:46 -0500
MIME-Version: 1.0
Date: Mon, 6 Feb 2012 09:40:45 -0600
Message-ID: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
Subject: Soft lockup problem
From: Gerard Saraber <gsaraber@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings everyone,
I've been having a bit of a problem since upgrading to the linux 3.x
series, I have a machine that we're using as a NAS that runs various
rsync processes (mostly at night), lately after a day or two, I will
come in in the morning to a load average of 49, but the machine not
really doing anything, when trying to run 'dstat' the command just
hung with no output at all. there were no errors in the logs, or even
anything that would vaguely point at anything I could work with.
So needing to get the machine back to work I attempted to reboot it
"shutdown -r now" on console... it gives a nice message saying it's
going to reboot, but nothing ever happens.. the only way to reboot it
is by using ctrl + alt + sysrq + b. after which the machine reboots
and the raid array comes back clean.

I'm not sure how to troubleshoot this, any pointers would be appreciated.

I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
options in the kernel debugging section:
detect hard/soft lockups and detect hung tasks, maybe it'll give me
something more to go on.

Some details about the machine:
Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
together into a 23TB XFS filesystem.
6GB memory and a pair of Intel Gigabit ethernet controllers bonded together.
