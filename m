Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab1EBIsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:48:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab1EBIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=ZaMMJrdkDxshFDbfORpVtgR8rKDxiVyWGDqrNAKFnMV2YEw+OG9lm3wB3NSDVLWKjN
         JgjqGDgzYTXBcORWXfM0GDfauFNi3VvaGT7Kuprsd6LEMMnbU1rpOi+/zhoedZ3/Bz5/
         rqxBYE6oeK/B82SyYQfIcMSb0reYPCDXBADCQ=
MIME-Version: 1.0
From: nidhi mittal hada <nidhimittal19@gmail.com>
Date: Mon, 2 May 2011 14:17:35 +0530
Message-ID: <BANLkTi=7hD1B-ytBApDiqmEcsBMPKRWakw@mail.gmail.com>
Subject: using usb serial gadget on linux on beagleboard
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

I have done
modprobe g_serial on my BeagleBoard to use usb as serial port on Beagleboard

I have taken the program on the link below as suggested by Jan axelson ...
for testing uart communication on BeagleBoard xm
http://www.lvr.com/code/usb_serial_port.c
I have connected BeagleBoard uart to windows hyperterminal and its
connected successfully .
Now i am able to write on uart from Beagleboard side ..



but as i read on Beagleboard ..i.e write something on Hyperterminal ..at once
These ERROR MESSAGES come on Beagleboard !!


[  236.729919] musb g_serial gadget disconnected.
[  238.990112] g_serial gadget: high speed config #2: CDC ACM config
[  274.613616] ------------[ cut here ]------------
[  274.618286] WARNING: at kernel/mutex.c:207 __mutex_lock_slowpath+0x6c/
0x278()
[  274.625488] Modules linked in: g_serial rfcomm ipv6 hidp l2cap
bluetooth rfkill
[  274.632965] [<c0040c40>] (unwind_backtrace+0x0/0xdc) from
[<c006cdb4>] (warn_slowpath_common+0x4c/0x80)
[  274.642425] [<c006cdb4>] (warn_slowpath_common+0x4c/0x80) from
[<c04852a0>] (__mutex_lock_slowpath+0x6c/0x278)
[  274.652496] [<c04852a0>] (__mutex_lock_slowpath+0x6c/0x278) from
[<c04854b8>] (mutex_lock+0xc/0x1c)
[  274.661621] [<c04854b8>] (mutex_lock+0xc/0x1c) from [<c029c014>]
(echo_set_canon_col+0x18/0x40)
[  274.670379] [<c029c014>] (echo_set_canon_col+0x18/0x40) from
[<c029e4d8>] (n_tty_receive_buf+0xc54/0xf38)
[  274.680023] [<c029e4d8>] (n_tty_receive_buf+0xc54/0xf38) from
[<c02a0c70>] (flush_to_ldisc+0x114/0x1e0)
[  274.689514] [<c02a0c70>] (flush_to_ldisc+0x114/0x1e0) from
[<bf09ce3c>] (gs_rx_push+0x140/0x220 [g_serial])
[  274.699340] [<bf09ce3c>] (gs_rx_push+0x140/0x220 [g_serial]) from
[<c0072e00>] (tasklet_action+0x74/0xbc)
[  274.708984] [<c0072e00>] (tasklet_action+0x74/0xbc) from
[<c0073400>] (__do_softirq+0xe8/0x1f0)
[  274.717742] [<c0073400>] (__do_softirq+0xe8/0x1f0) from
[<c007354c>] (irq_exit+0x44/0x98)
[  274.725982] [<c007354c>] (irq_exit+0x44/0x98) from [<c003b078>]
(asm_do_IRQ+0x78/0x98)
[  274.733947] [<c003b078>] (asm_do_IRQ+0x78/0x98) from [<c003bd40>]
(__irq_usr+0x40/0xa0)
[  274.742004] Exception stack(0xdfbabfb0 to 0xdfbabff8)
[  274.747100] bfa0:                                     00000000
be9bbcdd 0000000a 00000003
[  274.755340] bfc0: 40020000 00000000 00008588 00000003 00000000
00000000 40025000 be9bbccc
[  274.763580] bfe0: 00000000 be9bbcb8 000089f0 400da29c 60000010 ffffffff
[  274.770233] ---[ end trace c191d2c1d7b00f1e ]---


please help me to interpret and how could i correct this ...


Thanks
Nidhi
