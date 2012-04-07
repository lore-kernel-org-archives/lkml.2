Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2DGMXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 08:23:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37718 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2DGMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 08:23:13 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 7 Apr 2012 20:22:28 +0800
Message-ID: <CANFwon0eYTLHwtXJReu6g9rxwosLvOC2A25-f190GWBsngN58g@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120406 release(hotcode
 analyzer hotcode.py can output html)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel debugger and tracer.
It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine (see
https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp) can
debug and trace Linux through GDB tracepoint without stopping the
Linux Kernel. And even if the board doesn't have GDB on it and doesn't
have interface for remote debug. It can debug the Linux Kernel using
offline debug (See
https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug).
And it can work with Android (See
https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20120406 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120406.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120406

In the 20120319 release, KGTP include a add-ons hotcode.py that can
show the hotest code line in the Kernel or user space program without
interrupt them through parse and record the pc address in the irq
handler.  But it just can show the hotcode info to terminal.  Now, it
can save the hotcode info to a html file.  Then you can get more clear
info from hotcode.py.  You can get a example in
http://teawater.users.sourceforge.net/hotcode/normal.html
And I wrote a doc "an example to use KGTP analyze application
performance bottleneck" to show hot to use it increase the performance
in http://code.google.com/p/kgtp/wiki/hotcode

The other change of this release is:
Fix build error with Linux kernel that older than 2.6.34 in ARM.
Thanks report and help from Adam Huang.
Update howto.txt (http://code.google.com/p/kgtp/wiki/HOWTO) to make it
more clear.
Update the GDB in http://code.google.com/p/gdbt/ (add static binary
and change the source of code) to make people use it easily.
Fix bug of add-ons/hotcode.py when it use with user space task.
getmod.py auto call "set pagination off".
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

The other change of this release is:
Fix bug with GDB RSP package sum check.
Increase the speed of access to trace state variables.
Increase the speed of agent code execution.
Remove the current agent code "printf" support because GDB will
support new format of agent code "printf".
Fix bug about access $current_task_pid.
Add new debug switch GTP_DEBUG_V (just for developer).
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  I will post the patch
for review to linux-kernel@vger.kernel.org in a separate mail.

Thanks,
Hui
