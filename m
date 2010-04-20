Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0DTMqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:46:15 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:45391 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0DTMqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:46:13 -0400
Message-ID: <4BCDA20E.9050601@davidnewall.com>
Date: Tue, 20 Apr 2010 22:16:06 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: warning at serial_write_room and serial_write
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

What do the warnings, below, mean?

Thanks,

David



Apr 20 20:03:04 ubuntu xinetd[2509]: added service telnet 
[file=/etc/inetd.conf] [line=1]
Apr 20 20:03:04 ubuntu xinetd[2509]: xinetd Version 2.3.14 started with 
libwrap loadavg options compiled i
n.
Apr 20 20:03:04 ubuntu xinetd[2509]: Started working: 2 available services
Apr 20 20:03:04 ubuntu kernel: [   87.409895] ------------[ cut here 
]------------
Apr 20 20:03:04 ubuntu kernel: [   87.409931] WARNING: at 
/build/buildd/linux-2.6.28/drivers/usb/serial/usb-serial.c:326 
serial_write_room+0x70/0x80 [usbserial]()
Apr 20 20:03:04 ubuntu kernel: [   87.409972] Modules linked in: ppdev 
parport_pc lp parport pl2303 usbserial serio_raw snd_usb_audio 
snd_usb_lib cm109 snd_rawmidi snd_seq_device snd_pcm snd_hwdep snd_timer 
snd soundcore snd_page_alloc pcspkr r6040 mii usbhid aufs exportfs fbcon 
tileblit font bitblit softcursor
Apr 20 20:03:04 ubuntu kernel: [   87.410199] Pid: 6, comm: events/0 Not 
tainted 2.6.28-15-generic #49-Ubuntu
Apr 20 20:03:04 ubuntu kernel: [   87.410227] Call Trace:
Apr 20 20:03:04 ubuntu kernel: [   87.410274]  [<c04fdfc6>] ? 
printk+0x18/0x1a
Apr 20 20:03:04 ubuntu kernel: [   87.410315]  [<c0139c14>] 
warn_on_slowpath+0x54/0x80
Apr 20 20:03:04 ubuntu kernel: [   87.410370]  [<c012fae0>] ? 
finish_task_switch+0xb0/0xe0
Apr 20 20:03:04 ubuntu kernel: [   87.410405]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:04 ubuntu kernel: [   87.410444]  [<c01ae86f>] ? 
dma_pool_alloc+0x10f/0x120
Apr 20 20:03:04 ubuntu kernel: [   87.410477]  [<c01ae86f>] ? 
dma_pool_alloc+0x10f/0x120
Apr 20 20:03:04 ubuntu kernel: [   87.410530]  [<d0f23660>] 
serial_write_room+0x70/0x80 [usbserial]
Apr 20 20:03:04 ubuntu kernel: [   87.410573]  [<c03c8d9a>] ? 
handshake_on_error_set_halt+0x2a/0x90
Apr 20 20:03:04 ubuntu kernel: [   87.410609]  [<c03320b8>] 
tty_write_room+0x18/0x20
Apr 20 20:03:04 ubuntu kernel: [   87.410653]  [<c032fa5a>] opost+0x1a/0x260
Apr 20 20:03:04 ubuntu kernel: [   87.410683]  [<c032fccd>] 
echo_char+0x2d/0x70
Apr 20 20:03:04 ubuntu kernel: [   87.410713]  [<c0331567>] 
n_tty_receive_char+0x157/0x6f0
Apr 20 20:03:04 ubuntu kernel: [   87.410748]  [<c03ca2b9>] ? 
qh_schedule+0x169/0x2e0
Apr 20 20:03:04 ubuntu kernel: [   87.410780]  [<c0331d50>] 
n_tty_receive_buf+0x250/0x4b0
Apr 20 20:03:04 ubuntu kernel: [   87.410814]  [<c0127cad>] ? 
update_curr+0x8d/0x1e0
Apr 20 20:03:04 ubuntu kernel: [   87.410850]  [<c012adb6>] ? 
dequeue_entity+0x16/0x2a0
Apr 20 20:03:04 ubuntu kernel: [   87.410883]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:04 ubuntu kernel: [   87.410918]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:04 ubuntu init: set_tcp_rto_max main process (2556) 
terminated with status 2
Apr 20 20:03:04 ubuntu kernel: [   87.410953]  [<c03343ae>] 
flush_to_ldisc+0xee/0x1b0
Apr 20 20:03:04 ubuntu kernel: [   87.410983]  [<c03342c0>] ? 
flush_to_ldisc+0x0/0x1b0
Apr 20 20:03:04 ubuntu kernel: [   87.411014]  [<c014b0dd>] 
run_workqueue+0x8d/0x150
Apr 20 20:03:04 ubuntu kernel: [   87.411051]  [<c014f03a>] ? 
prepare_to_wait+0x3a/0x70
Apr 20 20:03:04 ubuntu kernel: [   87.411080]  [<c014b358>] 
worker_thread+0x88/0xf0
Apr 20 20:03:04 ubuntu kernel: [   87.411110]  [<c014ede0>] ? 
autoremove_wake_function+0x0/0x50
Apr 20 20:03:04 ubuntu kernel: [   87.411140]  [<c014b2d0>] ? 
worker_thread+0x0/0xf0
Apr 20 20:03:04 ubuntu kernel: [   87.411169]  [<c014ea3c>] 
kthread+0x3c/0x70
Apr 20 20:03:04 ubuntu kernel: [   87.411197]  [<c014ea00>] ? 
kthread+0x0/0x70
Apr 20 20:03:05 ubuntu kernel: [   87.411231]  [<c0105477>] 
kernel_thread_helper+0x7/0x10
Apr 20 20:03:05 ubuntu kernel: [   87.411256] ---[ end trace 
62523b8bb1bd4d2e ]---
Apr 20 20:03:05 ubuntu kernel: [   87.411307] ------------[ cut here 
]------------
Apr 20 20:03:05 ubuntu kernel: [   87.411330] WARNING: at 
/build/buildd/linux-2.6.28/drivers/usb/serial/usb-serial.c:313 
serial_write+0x9f/0xb0 [usbserial]()
Apr 20 20:03:05 ubuntu kernel: [   87.411362] Modules linked in: ppdev 
parport_pc lp parport pl2303 usbserial serio_raw snd_usb_audio 
snd_usb_lib cm109 snd_rawmidi snd_seq_device snd_pcm snd_hwdep snd_timer 
snd soundcore snd_page_alloc pcspkr r6040 mii usbhid aufs exportfs fbcon 
tileblit font bitblit softcursor
Apr 20 20:03:05 ubuntu kernel: [   87.411565] Pid: 6, comm: events/0 
Tainted: G        W  2.6.28-15-generic #49-Ubuntu
Apr 20 20:03:05 ubuntu kernel: [   87.411590] Call Trace:
Apr 20 20:03:05 ubuntu kernel: [   87.411620]  [<c04fdfc6>] ? 
printk+0x18/0x1a
Apr 20 20:03:05 ubuntu kernel: [   87.411651]  [<c0139c14>] 
warn_on_slowpath+0x54/0x80
Apr 20 20:03:05 ubuntu kernel: [   87.411694]  [<c012fae0>] ? 
finish_task_switch+0xb0/0xe0
Apr 20 20:03:05 ubuntu kernel: [   87.411725]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:05 ubuntu kernel: [   87.411756]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:05 ubuntu kernel: [   87.411808]  [<d0f2370f>] 
serial_write+0x9f/0xb0 [usbserial]
Apr 20 20:03:05 ubuntu kernel: [   87.411849]  [<c032c2fb>] 
tty_put_char+0x2b/0x40
Apr 20 20:03:05 ubuntu kernel: [   87.411880]  [<c032faf1>] opost+0xb1/0x260
Apr 20 20:03:05 ubuntu kernel: [   87.411907]  [<c032fccd>] 
echo_char+0x2d/0x70
Apr 20 20:03:05 ubuntu kernel: [   87.411935]  [<c0331567>] 
n_tty_receive_char+0x157/0x6f0
Apr 20 20:03:05 ubuntu kernel: [   87.411968]  [<c03ca2b9>] ? 
qh_schedule+0x169/0x2e0
Apr 20 20:03:05 ubuntu kernel: [   87.411997]  [<c0331d50>] 
n_tty_receive_buf+0x250/0x4b0
Apr 20 20:03:05 ubuntu kernel: [   87.412029]  [<c0127cad>] ? 
update_curr+0x8d/0x1e0
Apr 20 20:03:05 ubuntu kernel: [   87.412061]  [<c012adb6>] ? 
dequeue_entity+0x16/0x2a0
Apr 20 20:03:05 ubuntu kernel: [   87.412091]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:05 ubuntu kernel: [   87.412122]  [<c0500273>] ? 
_spin_unlock_irqrestore+0x23/0x40
Apr 20 20:03:05 ubuntu kernel: [   87.412154]  [<c03343ae>] 
flush_to_ldisc+0xee/0x1b0
Apr 20 20:03:05 ubuntu kernel: [   87.412184]  [<c03342c0>] ? 
flush_to_ldisc+0x0/0x1b0
Apr 20 20:03:05 ubuntu kernel: [   87.412213]  [<c014b0dd>] 
run_workqueue+0x8d/0x150
Apr 20 20:03:05 ubuntu kernel: [   87.412246]  [<c014f03a>] ? 
prepare_to_wait+0x3a/0x70
Apr 20 20:03:05 ubuntu kernel: [   87.412275]  [<c014b358>] 
worker_thread+0x88/0xf0
Apr 20 20:03:05 ubuntu kernel: [   87.412306]  [<c014ede0>] ? 
autoremove_wake_function+0x0/0x50
Apr 20 20:03:05 ubuntu kernel: [   87.412336]  [<c014b2d0>] ? 
worker_thread+0x0/0xf0
Apr 20 20:03:05 ubuntu kernel: [   87.412366]  [<c014ea3c>] 
kthread+0x3c/0x70
Apr 20 20:03:05 ubuntu kernel: [   87.412393]  [<c014ea00>] ? 
kthread+0x0/0x70
Apr 20 20:03:05 ubuntu kernel: [   87.412426]  [<c0105477>] 
kernel_thread_helper+0x7/0x10
Apr 20 20:03:05 ubuntu kernel: [   87.412449] ---[ end trace 
62523b8bb1bd4d2e ]---

