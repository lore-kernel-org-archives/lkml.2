Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2FEJO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:14:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57127 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2FEJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:14:27 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 5 Jun 2012 17:13:44 +0800
Message-ID: <CANFwon17XNVcsSZsHmGtYnXtPuoGcNZgHtDUmZCvArVy8unkog@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120605 release(user task
 memory access and user task stack dump available now)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux debugger and tracer.
To use it, you don't need patch or rebuild the Linux kernel. Just
build KGTP module and insmod it is OK.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine can debug and trace Linux through
GDB tracepoint and some other functions without stopping the Linux
Kernel.
And even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel using
offline debug (See
HOWTO#/sys/kernel/debug/gtpframe_and_offline_debug).
KGTP supports X86-32, X86-64, MIPS and ARM.
KGTP is tested on Linux kernel 2.6.18 to upstream.
And it can work with Android (See
http://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).

Please go to http://code.google.com/p/kgtp/wiki/HOWTO or
http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info
about howto use KGTP.

Now, KGTP 20120605 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120605.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120605

The main change of this release is:
Add new function "Read memory of user space program directly".
And use this function will not interrupt this task.
Please goto http://code.google.com/p/kgtp/wiki/HOWTO#Read_memory_of_user_space_program_directly
to get more info about it.

Add new function "collect stack (for backtrace) of user space program
in tracepoint".
With this function, you can get the stack dump of an user task from
user space to Kernel space.
Please goto http://code.google.com/p/kgtp/wiki/HOWTO#collect_stack_(for_backtrace)_of_user_space_program_in_tracepoin
to get more info about it.

Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
about this release.

According to the comments of Christoph, Geoff and Andi.  I make lite
patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
see it.

Thanks,
Hui
