Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2HQWaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:30:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab2HQWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:30:12 -0400
MIME-Version: 1.0
Date: Fri, 17 Aug 2012 18:30:11 -0400
Message-ID: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
Subject: mdraid6 problem post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the last few weeks I have been doing some reliability testing on a
 mdraid6 array. One of my test was to physically hot remove a raid
member disk. This worked flawlessly with gentoo-sources-3.5.0 for the
5 or so times I tried it with my 12 disk + 1 spare mdraid6 array.
After pulling a disk a few seconds later the array automatically
rebuilds with a spare and after finishing all data checks out via
btrfs a scrub. However trying this with gentoo-sources-3.5.2 or the
latest kernel.org git sources the machine does not start the rebuild
and any access to /proc/mdstat or and disk access that is not in cache
for that array just leads to an a long (possibly infinite) wait
eventually forcing me to have to use the reset button when the sysrq
key combinations fail to shut down the machine. I do see some kernel
debug message in the console alt-ctrl-f12 but I was unable to save
that to copy.

Is this a known problem? If not it may be possible that I could bisect
this next week to the patch that causes this behavior.

-- 
John M. Drescher
