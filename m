Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1LRMMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 07:12:07 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47494 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1LRMMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 07:12:03 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 18 Dec 2011 20:11:20 +0800
Message-ID: <CANFwon3hXH-1PQi1XZsxjFFDQ4Z0X25db87rJYG_4DF2ZXGLeQ@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20111218 release
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel debugger and tracer.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine (see
https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp) can
debug and trace Linux through GDB tracepoint without stopping the
Linux Kernel.
And even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel using
offline debug (See
https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug).
And it can work with Android (See
https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20111218 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20111218.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20111218

The change of this release is:
Add gtp_rb to be the new frame buffer to make trace record speed up
and more friendly to the older version Linux kernel.
Rename gtp.patch to gtp_for_review.patch.
Add Linux Kernel patch gtp_3.0_to_upstream.patch(3.0 to upstream),
gtp_2.6.39.patch(2.6.39), gtp_2.6.33_to_2.6.38.patch(2.6.33 to 2.6.38)
and gtp_older_to_2.6.32.patch(older to 2.6.32).
Then you can include KGTP in your Kernel source tree.
Add special trace state variable $gtp_version to show the version of KGTP.
Fix some build errors of gtp_for_review.patch.
Fix some build errors in ARM.
Update doc.
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  The file
gtp_for_review.patch is include in the source of KGTP code.

Thanks,
Hui
