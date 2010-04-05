Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0DENnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:43:46 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:2181
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab0DENnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:43:39 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 09:43:38 EDT
X-Trace: 196654724/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.4 (Linux/2.6.33.1; KDE/4.3.5; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC+DuUtTQwwf/2dsb2JhbACbSnK0GoUHBA
X-IronPort-AV: E=Sophos;i="4.51,366,1267401600"; 
   d="scan'208";a="196654724"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Ooops when working with USB MIDI (2.6.33.1)
Date: Mon, 5 Apr 2010 14:33:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.1; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004051433.47171.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I had TuxGuitar running and an external USB MIDI device, which I then turned off, on, and exited TuxGuitar at which point there was this oops.

See the pasted block below, 

Tvrtko

[321144.695235] usb 3-3: new full speed USB device using ohci_hcd and address 3                                                                     
[321144.847033] usb 3-3: New USB device found, idVendor=0499, idProduct=1030                                                                        
[321144.847036] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0                                                                   
[321144.847038] usb 3-3: Product: YAMAHA PSR295_3                                                                                                   
[321144.847039] usb 3-3: Manufacturer: YAMAHA Corporation                                                                                           
[321182.618331] BUG: unable to handle kernel paging request at 00000007000400bc                                                                     
[321182.618342] IP: [<ffffffff81375d65>] _raw_spin_lock_irq+0x15/0x30                                                                               
[321182.618350] PGD 3e62067 PUD 0                                                                                                                   
[321182.618354] Oops: 0002 [#1] PREEMPT SMP                                                                                                         
[321182.618358] last sysfs file: /sys/devices/platform/it87.656/temp1_input                                                                         
[321182.618362] CPU 3                                                                                                                               
[321182.618367] Pid: 8030, comm: java Not tainted 2.6.33.1 #11 M4A785TD-M EVO/System Product Name                                                   
[321182.618371] RIP: 0010:[<ffffffff81375d65>]  [<ffffffff81375d65>] _raw_spin_lock_irq+0x15/0x30                                                   
[321182.618377] RSP: 0018:ffff88005c42dda0  EFLAGS: 00010002                                                                                        
[321182.618381] RAX: 0000000000000100 RBX: ffff88002daa6900 RCX: 0000000000000000                                                                   
[321182.618385] RDX: 0000000000000032 RSI: 0000000000001000 RDI: 00000007000400bc                                                                   
[321182.618389] RBP: 0000000700040008 R08: 0000000000000000 R09: 0000000000000000
[321182.618393] R10: 0000000000000000 R11: 0000000000000202 R12: 00000007000400bc
[321182.618396] R13: ffff880010e634e0 R14: ffff88011dbf3400 R15: 0000000000000032
[321182.618401] FS:  00007fccb3b38910(0000) GS:ffff8800282c0000(0000) knlGS:00000000eed53b70
[321182.618405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[321182.618408] CR2: 00000007000400bc CR3: 0000000045e2c000 CR4: 00000000000006e0
[321182.618412] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[321182.618416] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[321182.618420] Process java (pid: 8030, threadinfo ffff88005c42c000, task ffff880112e23400)
[321182.618424] Stack:
[321182.618426]  ffffffffa01e2fca 0000000000000000 ffff880112e23400 ffffffff81052260
[321182.618430] <0> ffff88005c42ddc0 ffff88005c42ddc0 00007fcc90547515 ffffea0001bac888
[321182.618435] <0> ffff88002daa6900 ffff88000ed8e000 0000000000000000 ffff880010e634e0
[321182.618442] Call Trace:
[321182.618449]  [<ffffffffa01e2fca>] ? snd_usbmidi_output_drain+0x7a/0x100 [snd_usb_lib]
[321182.618455]  [<ffffffff81052260>] ? autoremove_wake_function+0x0/0x30
[321182.618462]  [<ffffffffa01b7699>] ? snd_rawmidi_drain_output+0x119/0x180 [snd_rawmidi]
[321182.618469]  [<ffffffffa01b8625>] ? close_substream+0x35/0x100 [snd_rawmidi]
[321182.618475]  [<ffffffffa01b874b>] ? rawmidi_release_priv+0x5b/0xa0 [snd_rawmidi]
[321182.618480]  [<ffffffffa01b87b6>] ? snd_rawmidi_release+0x26/0x60 [snd_rawmidi]
[321182.618486]  [<ffffffff810c6681>] ? __fput+0xd1/0x1f0
[321182.618491]  [<ffffffff810c2ec6>] ? filp_close+0x56/0x90
[321182.618494]  [<ffffffff810c2fb4>] ? sys_close+0xb4/0x110
[321182.618499]  [<ffffffff810025ab>] ? system_call_fastpath+0x16/0x1b
[321182.618503] Code: c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c3 66 0f 1f 84 00 00 00 00 00 fa 65 48 8b 04 25 48 b5 00 00 ff 80 44 e0 ff ff b8 00 01 
00 00 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 2e 0f 1f
[321182.618527] RIP  [<ffffffff81375d65>] _raw_spin_lock_irq+0x15/0x30
[321182.618532]  RSP <ffff88005c42dda0>
[321182.618534] CR2: 00000007000400bc
[321182.618538] ---[ end trace d9f48627b5dd1198 ]---
[321182.618542] note: java[8030] exited with preempt_count 1
