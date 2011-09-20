Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab1ITT1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:27:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54080 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1ITT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:27:01 -0400
MIME-Version: 1.0
From: =?UTF-8?B?0JDQvdGC0L7QvSDQndC+0LLQuNC60L7Qsg==?= 
	<tonn.post@gmail.com>
Date: Tue, 20 Sep 2011 23:26:41 +0400
Message-ID: <CAPoN8K0M2uROGv94Q+bXEkSN47irviPA99jNUBhD6u5qJmm1mA@mail.gmail.com>
Subject: DRM troubles with kernel >=2.6.33
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I've got laptop dell inspiron 1521 with ati x1270 (rs690).
Since kernel version 2.6.33 while I turn KMS on all opengl programms
hangs with backtrace like this:
~/ $ gdb `which glxgears`
...
(gdb) bt
#0  0x00007ffff761ccb8 in poll () from /lib64/libc.so.6
#1  0x00007ffff63c2b5a in ?? () from /usr/lib64/libxcb.so.1
#2  0x00007ffff63c474c in xcb_wait_for_reply () from /usr/lib64/libxcb.so.1
#3  0x00007ffff7259375 in _XReply () from /usr/lib64/libX11.so.6
#4  0x00007ffff7bb3cda in ?? () from /usr/lib64/opengl/xorg-x11/lib/libGL.so.1
#5  0x00007ffff7bb1b79 in ?? () from /usr/lib64/opengl/xorg-x11/lib/libGL.so.1
#6  0x00007ffff48dd7a1 in ?? () from /usr/lib64/dri/r300_dri.so
#7  0x00007ffff48de7b9 in ?? () from /usr/lib64/dri/r300_dri.so
#8  0x00007ffff492392a in ?? () from /usr/lib64/dri/r300_dri.so
#9  0x00007ffff4924ea6 in ?? () from /usr/lib64/dri/r300_dri.so
#10 0x00007ffff4a4dac8 in ?? () from /usr/lib64/dri/r300_dri.so
#11 0x00007ffff4a53fda in ?? () from /usr/lib64/dri/r300_dri.so
#12 0x0000000000401c9e in ?? ()
#13 0x0000000000403332 in ?? ()
#14 0x00007ffff756febd in __libc_start_main () from /lib64/libc.so.6
#15 0x0000000000401a79 in ?? ()
#16 0x00007fffffffe2e8 in ?? ()
#17 0x000000000000001c in ?? ()
#18 0x0000000000000001 in ?? ()
#19 0x00007fffffffe63b in ?? ()
#20 0x0000000000000000 in ?? ()

I've tried different versions of xf86-video-ati, mesa (classic,
gallium), but this trouble depends only on kernel version.
If I turn off kms - all works fine but only in classic mode.
