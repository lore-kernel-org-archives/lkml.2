Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2LJCxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:53:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42906 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LJCxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:53:04 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 10 Dec 2012 10:52:22 +0800
Message-ID: <CANFwon0-QQygKUmRq6E3QawbFqkPc1zy2Om2E7qvCXB-LZdbFQ@mail.gmail.com>
Subject: KGTP (Linux debugger and tracer) 20121204 release (bug fix and doc update)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>,
        Oliver Yang <yangoliver@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

KGTP (http://code.google.com/p/kgtp/) is a flexible , lightweight and
realtime Linux debugger and tracer.
To use it, you don't need patch or rebuild the Linux kernel. Just
build KGTP module and insmod it is OK.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine can debug and trace Linux through
GDB tracepoint and some other functions without stopping the Linux
Kernel.
And even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel using
offline debug (See
http://code.google.com/p/kgtp/wiki/HOWTO#/sys/kernel/debug/gtpframe_and_offline_debug).
KGTP supports X86-32, X86-64, MIPS and ARM.
KGTP is tested on Linux kernel 2.6.18 to upstream.
And it can work with Android (See
http://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).

Please go to http://code.google.com/p/kgtp/wiki/HOWTO or
http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info
about howto use KGTP.

Now, KGTP 20121204 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20121204.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20121204

This release doesn't have any feature update.  Just fix some build
issue with old Linux kernel and ARM.  And update howto to make it more
clear.
Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
about this release.

According to the comments of Christoph, Geoff and Andi.  I make lite
patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
see it.

Thanks,
Hui
