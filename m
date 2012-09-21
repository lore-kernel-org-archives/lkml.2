Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2IUDSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:18:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65246 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2IUDSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:18:15 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 21 Sep 2012 11:17:34 +0800
Message-ID: <CANFwon2wn6fWE6RDq0QwCp-rhZvxyqLZodNoHeo-9iUw-nnpMw@mail.gmail.com>
Subject: KGTP (Linux debugger and tracer) 20120920 release (add LKM plugin and
 per cpu TSV update)
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

Hi guys,

KGTP is a flexible , lightweight and realtime Linux debugger and tracer.
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

Now, KGTP 20120920 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120920.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120920

The main change of this release is:
C plugin support.  With this function, you can dynamic add new
function to KGTP with LKM.
To get more info about it.  Please goto
http://code.google.com/p/kgtp/wiki/HOWTO#How_to_add_plugin_in_C

Per_cpu trace state variables function was updated.  The usage and
format was changed.  This change make it more easy to be used.  And I
also update the doc to make it more clear.  Please goto
http://code.google.com/p/kgtp/wiki/HOWTO#Per_cpu_trace_state_variables
get it.

Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
about this release.

According to the comments of Christoph, Geoff and Andi.  I make lite
patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
see it.

Thanks,
Hui
