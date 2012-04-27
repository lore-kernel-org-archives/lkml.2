Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab2D0PmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:42:15 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:25310 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504Ab2D0PmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:42:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMCACxOgk8Y9geI/2dsb2JhbAANNoUeVbAGhkoBAQEBAgEMFw8BRQEFCwkCGAICBQ0BCAsCAgkDAgECAUUGDQEFAgEBiAUQrA+KGIEviX2CBgGCD4EYBJBsCYYIkiiBOgY
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="177133005"
Message-ID: <4F9ABE54.4060603@teksavvy.com>
Date: Fri, 27 Apr 2012 11:42:12 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?IkZyw6lkw6lyaWMgTC4gVy4gTWV1bmllciI=?= 
	<fredlwm@fredlwm.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: What may be causing this kernel panic ?
References: <20120427013225.GA1011@pervalidus> <CAJK5xJRPF1XtXXYtZ_GQONstPrBa_eaeqW=XACSx+giFWBpfnQ@mail.gmail.com> <20120427083456.GB21929@liondog.tnic> <20120427141115.GB1011@pervalidus> <CAJK5xJTsKZVsb1vwXzdCmeZ+oOLiv0eB9A0GkShu0rM8Xac6Jg@mail.gmail.com>
In-Reply-To: <CAJK5xJTsKZVsb1vwXzdCmeZ+oOLiv0eB9A0GkShu0rM8Xac6Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-27 11:26 AM, Frédéric L. W. Meunier wrote:
> 2012/4/27 Frédéric L. W. <fredlwm@fredlwm.net>:
>> On Fri, Apr 27, 2012 at 10:34:56AM +0200, Borislav Petkov wrote:
>>> On Fri, Apr 27, 2012 at 03:11:11AM -0300, Frédéric L. W. Meunier wrote:
>>>> https://sites.google.com/a/fredlwm.net/fredlwm/home/kernelpanic2.png
>>>> is more complete and shows something about the keyboard, I guess.
>>>
>>> Can you pls attach this second kernelpanic2.jpg to the mail too - the
>>> thing above wants a login/pwd.
>>
>> Sorry, I thought it was public. Try
>> http://img826.imageshack.us/img826/198/kernelpanic2.png
> 
> Better yet, I got the full kernel panic from a serial console.

> kernelpanic.txt
> 
> [   26.685724] BUG: unable to handle kernel paging request at ffffffff00000079
> [   26.686551] IP: [<ffffffff81172e37>] puts_queue.isra.15+0x25/0x3b
> [   26.686551] PGD 1607067 PUD 0
> [   26.686551] Oops: 0000 [#1] PREEMPT SMP
> [   26.686551] CPU 0
> [   26.686551] Modules linked in: agpgart snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm psmouse processor snd_page_alloc joydev evdev thermal_sys snd_timer button e1000 i2c_piix4 snd hwmon i2c_core sg soundcore loop ext4 crc16d
> [   26.686551]
> [   26.686551] Pid: 0, comm: swapper/0 Not tainted 3.3.3 #2 innotek GmbH VirtualBox
> [   26.686551] RIP: 0010:[<ffffffff81172e37>]  [<ffffffff81172e37>] puts_queue.isra.15+0x25/0x3b
> [   26.686551] RSP: 0018:ffff88000f603c08  EFLAGS: 00010086
> [   26.686551] RAX: 0000000000000001 RBX: ffff88000e7a2800 RCX: ffffffff81039201
> [   26.686551] RDX: 0000000000000000 RSI: ffffffff00000079 RDI: ffff88000e7a2800
> [   26.686551] RBP: ffff88000f603c18 R08: 0000000000000000 R09: 000000000000007f
> [   26.686551] R10: 0000000000000027 R11: ffffffff81704e78 R12: ffffffff00000079
> [   26.686551] R13: 0000000000000001 R14: ffffffff8162f102 R15: 0000000000000000
> [   26.686551] FS:  00007f0a6463c740(0000) GS:ffff88000f600000(0000) knlGS:0000000000000000
> [   26.686551] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   26.686551] CR2: ffffffff00000079 CR3: 000000000e7df000 CR4: 00000000000006f0
> [   26.686551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   26.686551] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   26.686551] Process swapper/0 (pid: 0, threadinfo ffffffff81600000, task ffffffff8160d020)
> [   26.686551] Stack:
> [   26.686551]  ffff88000f008000 000000000000003d ffff88000f603c28 ffffffff81172eed
> [   26.686551]  ffff88000f603c98 ffffffff81173a52 ffffffff81046301 00ff88000e649800
> [   26.686551]  ffff880000000001 ffff88000f008000 0000000000000001 0000f10200000000
> [   26.686551] Call Trace:
> [   26.686551]  <IRQ>
> [   26.686551]  [<ffffffff81172eed>] k_fn+0x21/0x23
> [   26.686551]  [<ffffffff81173a52>] kbd_event+0x50d/0x577
> [   26.686551]  [<ffffffff81046301>] ? try_to_wake_up+0x158/0x1c3
> [   26.686551]  [<ffffffff8119396d>] input_pass_event+0x8f/0xd5
> [   26.686551]  [<ffffffff81195660>] input_handle_event+0x479/0x488
> [   26.686551]  [<ffffffff811816fd>] ? add_timer_randomness+0x117/0x11e
> [   26.686551]  [<ffffffff81195761>] input_event+0x64/0x83
> [   26.686551]  [<ffffffff8119896b>] atkbd_interrupt+0x46a/0x537
> [   26.686551]  [<ffffffff8104f09c>] ? ktime_get+0x57/0x90
> [   26.686551]  [<ffffffff81190964>] serio_interrupt+0x40/0x7c
> [   26.686551]  [<ffffffff8119194b>] i8042_interrupt+0x294/0x2a6
> [   26.686551]  [<ffffffff81067369>] handle_irq_event_percpu+0x29/0x11b
> [   26.686551]  [<ffffffff81067497>] handle_irq_event+0x3c/0x5d
> [   26.686551]  [<ffffffff81018e7a>] ? ack_APIC_irq+0x10/0x12
> [   26.686551]  [<ffffffff810699bf>] handle_edge_irq+0x9c/0xc1
> [   26.686551]  [<ffffffff81003fe3>] handle_irq+0x1f/0x25
> [   26.686551]  [<ffffffff81003d0e>] do_IRQ+0x48/0xa0
> [   26.686551]  [<ffffffff812231eb>] common_interrupt+0x6b/0x6b
> [   26.686551]  <EOI>
> [   26.686551]  [<ffffffff81222ee3>] ? _raw_spin_unlock_irqrestore+0x21/0x2c
> [   26.686551]  [<ffffffff81009677>] ? default_idle+0x22/0x37
> [   26.686551]  [<ffffffff81009671>] ? default_idle+0x1c/0x37
> [   26.686551]  [<ffffffff81009842>] amd_e400_idle+0xce/0xd0
> [   26.686551]  [<ffffffff8100122a>] cpu_idle+0x64/0xb2
> [   26.686551]  [<ffffffff8120dfc8>] rest_init+0x8c/0x90
> [   26.686551]  [<ffffffff8164d89f>] start_kernel+0x31b/0x327
> [   26.686551]  [<ffffffff8164d0b1>] x86_64_start_reservations+0xae/0xb2
> [   26.686551]  [<ffffffff8164d000>] ? 0xffffffff8164cfff
> [   26.686551]  [<ffffffff8164d1a1>] x86_64_start_kernel+0xec/0xf3
> [   26.686551] Code: 01 5b 41 5c 5d c3 55 48 85 ff 48 89 e5 41 54 49 89 f4 53 48 89 fb 75 13 eb 22 40 0f b6 f6 31 d2 48 89 df 49 ff c4 e8 00 f7 ff ff <41> 8a 34 24 40 84 f6 75 e6 48 89 df e8 6b f7 ff ff 5b 41 5c 5d
> [   26.686551] RIP  [<ffffffff81172e37>] puts_queue.isra.15+0x25/0x3b
> [   26.686551]  RSP <ffff88000f603c08>
> [   26.686551] CR2: ffffffff00000079
> [   26.686551] ---[ end trace f4cadcd8b64eb3a2 ]---
> [   26.686551] Kernel panic - not syncing: Fatal exception in interrupt


If anyone goes into the code to look at this, I do wonder if it might be
related to a bug I've been seeing in 3.2.xx/3.3.xx whereby the input system
(or X11?) often fails to notice I've released a keyboard button..
and the auto-repeat just keeps on going until I press/release another button
to stop it.

Bot the ooops above and the repeat issue could be due to the same/similar race
somewhere in there.  Or not.  Just keep your eyes and mind open to the possibility. :)

Cheers
