Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1KNFPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:15:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48143 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1KNFPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:15:05 -0500
MIME-Version: 1.0
Date: Mon, 14 Nov 2011 13:15:03 +0800
Message-ID: <CANFwon04fJe9z+5wKXp55Kp-SX+FZyAhnNcAH9zi6zBd++GSFg@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20111111 release (Android
 support OK)
From: Hui Zhu <teawater@gmail.com>
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine can debug and trace Linux through
GDB tracepoint without stopping the Linux Kernel.
And even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel using
offline debug.
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20111111 release.

The change of this release is:
Add a doc for use KGTP with Android in
https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid
post_handler will make kprobes-optimization cannot be used. So make
gtp_kp_post_handler be call only when tpe->step is true.
Make rdtsc_current to x86 special.
Register easy Kprobe handler to speed up it when no tracepoint access
$cooked_clock, $cooked_rdtsc or "pc_pe" tvariable.
Fix a bug of ARM build.
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  The file gtp.patch is
include in the source of KGTP code.

Thanks,
Hui
