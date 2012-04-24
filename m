Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2DXNT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:19:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2DXNTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:19:25 -0400
Message-ID: <4F96A849.2090108@gmail.com>
Date: Tue, 24 Apr 2012 21:19:05 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
CC: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120424 release(doc update)[0/3]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel debugger and tracer.
It makes Linux Kernel supply a GDB remote debug interface. Then GDB in current machine or remote machine can debug and trace Linux through GDB tracepoint and some other functions without stopping the Linux Kernel.
And even if the board doesn't have GDB on it and doesn't have interface for remote debug. It can debug the Linux Kernel using offline debug (See http://code.google.com/p/kgtp/wiki/HOWTO#/sys/kernel/debug/gtpframe_and_offline_debug).
And it can work with Android (See http://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
Now, it supports X86-32, X86-64, MIPS and ARM.

Please go to http://code.google.com/p/kgtp/wiki/HOWTO or http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info about howto use KGTP.

Now, KGTP 20120424 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120424.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120424

The change of this release is:
* Update "How to use /sys/kernel/debug/gtpframe_pipe" in howto.
   http://code.google.com/p/kgtp/wiki/HOWTO#How_to_use_/sys/kernel/debug/gtpframe_pipe

* Add How to handle "Unsupported operator (null) (52) in expression." to howto.
   http://code.google.com/p/kgtp/wiki/HOWTO#How_to_handle_"Unsupported_operator_(null)_(52)_in_expressi

* Separate actions and actions src to handle the status
   that will delete some actions.

* Add $bt to collect the stack and update the stack dump in the howto to make
   it more clear.
   http://code.google.com/p/kgtp/wiki/HOWTO#Howto_backtrace_(stack_dump)

* Update the format of example in the HOWTO to make it more clear.

* Remove the crc check and suport QStartNoAckMode+.

* Add Chinese howto.
   http://code.google.com/p/kgtp/wiki/HOWTOCN

* Update a lot of parts of howto to make it more clear.
   http://code.google.com/p/kgtp/wiki/HOWTO
   http://code.google.com/p/kgtp/wiki/HOWTOCN

* Add introduce of $_ret to howto.
   http://code.google.com/p/kgtp/wiki/HOWTO#Collect_stack_of_current_function's_caller_with_$_ret

According to the comments of Christoph and Geoff.  I make 3 patches for Linux Kernel and make it looks OK with checkpatch.pl.  I will post the patches for review to linux-kernel@vger.kernel.org in separate mails.

Thanks,
Hui
