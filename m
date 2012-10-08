Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2JHVEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:04:06 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45459 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2JHVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:04:02 -0400
MIME-Version: 1.0
X-Originating-IP: [71.62.63.105]
Date: Mon, 8 Oct 2012 17:04:02 -0400
Message-ID: <CAO9zADyRC8sSChC1whP+b46CsgObW-ygfsmdRxSPKcfW0Z9FGQ@mail.gmail.com>
Subject: 3.6.0 ACPI: e1000e - Invalid Power Resource to register! (Supermicro
 X9SCM-F) - Disabling IRQ #44
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, al piszcz <ap@solarrain.com>
Cc: linux-acpi@vger.kernel.org, e1000-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kernel: 3.6.0 (x86_64)
Distribution: Debian Testing

I was copying 600GB of files from Samba/Linux to a Windows host, it
copied around 500GB, then this happened, it disabled the network
interface on my Supermicro X9CM-F board (on-board) -- the first
interface, any idea why this happened?

[93593.565667] irq 44: nobody cared (try booting with the "irqpoll" option)
[93593.565673] Pid: 0, comm: swapper/0 Not tainted 3.6.0 #4
[93593.565675] Call Trace:
[    0.971861] ACPI: Invalid Power Resource to register!
[93593.565677]  <IRQ>  [<ffffffff810a6fe1>] __report_bad_irq+0x31/0xd0
[93593.565690]  [<ffffffff810a72c3>] note_interrupt+0x1a3/0x1f0
[93593.565694]  [<ffffffff810a4e59>] handle_irq_event_percpu+0x89/0x160
[93593.565697]  [<ffffffff810a4f6c>] handle_irq_event+0x3c/0x60
[93593.565700]  [<ffffffff810a7b7f>] handle_edge_irq+0x6f/0x110
[93593.565705]  [<ffffffff81003c6d>] handle_irq+0x1d/0x30
[93593.565709]  [<ffffffff81003b65>] do_IRQ+0x55/0xd0
[93593.565714]  [<ffffffff815fdb27>] common_interrupt+0x67/0x67
[93593.565715]  <EOI>  [<ffffffff8107d1ed>] ?
__hrtimer_start_range_ns+0x1bd/0x3b0
[93593.565728]  [<ffffffff81383894>] ? acpi_idle_enter_c1+0xaa/0xcf
[93593.565731]  [<ffffffff81383873>] ? acpi_idle_enter_c1+0x89/0xcf
[93593.565735]  [<ffffffff814a1719>] cpuidle_enter+0x19/0x20
[93593.565738]  [<ffffffff814a1a98>] cpuidle_idle_call+0x88/0x100
[93593.565750]  [<ffffffff8100a39f>] cpu_idle+0x5f/0xd0
[93593.565752]  [<ffffffff815e9a24>] rest_init+0x68/0x74
[93593.565755]  [<ffffffff81a8ca86>] start_kernel+0x2a8/0x2b5
[93593.565756]  [<ffffffff81a8c5dd>] ? repair_env_string+0x5e/0x5e
[93593.565758]  [<ffffffff81a8c2fd>] x86_64_start_reservations+0x101/0x105
[93593.565759]  [<ffffffff81a8c3d9>] x86_64_start_kernel+0xd8/0xdc
[93593.565760] handlers:
[93593.565762] [<ffffffff8140c330>] e1000_msix_other
[93593.565763] Disabling IRQ #44

Justin.
