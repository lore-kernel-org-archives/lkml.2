Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2LJARY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 19:17:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49691 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab2LJARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 19:17:23 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 01:17:21 +0100
Message-ID: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
Subject: "attempt to access beyond end of device" on DVD
From: Jacek Poplawski <jacekpoplawski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

few years ago I noticed annoying bug on Linux, when I was copying
photos from old DVDs I realized that not all files were copied
correctly, there were errors on last files on DVD, you could say "well
that happens, DVD are faulty", but that's not the real issue

when the problem appears it happens on each DVD I am trying to copy,
last files on each disk have errors....

...until I reboot Linux, then there are no errors at all and full DVD
is copied correctly.

Now I needed some files from DVDs and I realized the problem still
exists. After at least three years. I verified that reboot helps and I
also noticed the problem doesn't exist on Windows 7.

And looks like I wasn't only one who found this:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/404472

Problem was reported in 2009 on 2.6.28 and closed in 2012. But I
noticed it in last days.

my system is:

Linux version 3.6.8-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC)
) #1 SMP PREEMPT Mon Nov 26 22:10:40 CET 2012

dmesg:

[ 4017.384169] attempt to access beyond end of device
[ 4017.384171] sr0: rw=0, want=8511124, limit=8433216
[ 4017.384174] attempt to access beyond end of device
[ 4017.384175] sr0: rw=0, want=8510876, limit=8433216

I suspect that people just stopped using CDs and DVDs and that's why
nobody was looking on this problem, or maybe the first though was
always "that DVD is broken, trash it".

Is there more information I could give you about this issue? Or could
you point me to any ways I could debug it? It's fully reproducible on
my system.
