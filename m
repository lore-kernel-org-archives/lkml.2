Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1JZVJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:09:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57713 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1JZVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:09:37 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <vnc-list@realvnc.com>, <linux-kernel@vger.kernel.org>
Subject: 3.x/libc6 -- out of ideas -- launching chrome results in an immediate crash of Xvnc everytime
Date: Wed, 26 Oct 2011 17:09:27 -0400
Message-ID: <025301cc9423$8c70a320$a551e960$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AcyUI4L/IjKQ4c78TLqxPc4y41r/Fg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I launch google-chrome (stable or unstable) Xvnc crashes repeatedly:

-rw------- 1 user users 115228672 Oct 25 01:48 core.Xvnc4.19596
-rw------- 1 user users  50475008 Oct 26 04:29 core.Xvnc4.6774
-rw------- 1 user users  44830720 Oct 26 16:23 core.Xvnc4.4718
-rw------- 1 user users  44630016 Oct 26 16:30 core.Xvnc4.6127
-rw------- 1 user users  44437504 Oct 26 16:33 core.Xvnc4.6494
-rw------- 1 user users  44441600 Oct 26 16:33 core.Xvnc4.6822
-rw------- 1 user users  44425216 Oct 26 16:34 core.Xvnc4.7215
-rw------- 1 user users  44429312 Oct 26 16:39 core.Xvnc4.14728
-rw------- 1 user users  45207552 Oct 26 16:40 core.Xvnc4.15102
-rw------- 1 user users  45457408 Oct 26 16:52 core.Xvnc4.21274
-rw------- 1 user users  42004480 Oct 26 16:53 core.Xvnc4.23068
-rw------- 1 user users  42770432 Oct 26 16:55 core.Xvnc4.23388
-rw------- 1 user users  44892160 Oct 26 16:55 core.Xvnc4.23891
-rw------- 1 user users  45404160 Oct 26 16:56 core.Xvnc4.24206
-rw------- 1 user users  43442176 Oct 26 16:58 core.Xvnc4.24596
-rw------- 1 user users  41889792 Oct 26 17:00 core.Xvnc4.25128
-rw------- 1 user users  41885696 Oct 26 17:04 core.Xvnc4.14144

Already ran memtest86+ no memory problems, all passes ran 100% OK.

--

Can anyone offer any suggestions as how to further debug this issue?
I see Debian upgraded its glibc from 2.13-10 to 2.13-21 but I'm not sure if
that had anything to do with it, I did try the PRELOAD statements in the
Debian readme but with no success.

#0  0x00000000004cbed4 in ?? ()
(gdb) bt
#0  0x00000000004cbed4 in ?? ()
#1  0x00000000004dd577 in ?? ()
#2  0x00000000005832a2 in ?? ()
#3  0x00000000005834ff in ?? ()
#4  0x0000000000426d90 in ?? ()
#5  0x000000000040be86 in ?? ()
#6  0x00007f3d4d529ead in __libc_start_main () from
/lib/x86_64-linux-gnu/libc.so.6
#7  0x0000000000409259 in ?? ()
#8  0x00007fffa5a6fde8 in ?? ()
#9  0x000000000000001c in ?? ()
#10 0x0000000000000015 in ?? ()
#11 0x00007fffa5a70cba in ?? ()
#12 0x00007fffa5a70cc0 in ?? ()
#13 0x00007fffa5a70cc3 in ?? ()
#14 0x00007fffa5a70ccc in ?? ()
#15 0x00007fffa5a70cd8 in ?? ()
#16 0x00007fffa5a70cde in ?? ()
#17 0x00007fffa5a70cf4 in ?? ()
#18 0x00007fffa5a70cfe in ?? ()
#19 0x00007fffa5a70d08 in ?? ()
#20 0x00007fffa5a70d0f in ?? ()
#21 0x00007fffa5a70d12 in ?? ()
#22 0x00007fffa5a70d1b in ?? ()
#23 0x00007fffa5a70d21 in ?? ()
#24 0x00007fffa5a70d2a in ?? ()
#25 0x00007fffa5a70d40 in ?? ()
#26 0x00007fffa5a70d49 in ?? ()
#27 0x00007fffa5a70d4e in ?? ()
#28 0x00007fffa5a70d52 in ?? ()
#29 0x00007fffa5a70d56 in ?? ()
#30 0x00007fffa5a70e66 in ?? ()
#31 0x00007fffa5a70e6a in ?? ()
#32 0x0000000000000000 in ?? ()
(gdb)

Justin.

