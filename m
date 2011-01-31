Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1AaMIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:08:44 -0500
Received: from mailbox20.lycos.com ([209.202.250.20]:48760 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AaMIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:08:42 -0500
Date: Mon, 31 Jan 2011 07:08:36 -0500 (EST)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <17725266.49811296475716764.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <9147572.49771296475645053.JavaMail.root@mail-zbox20.bo3.lycos.com>
Subject: irq N: nobody cared (try booting with the "irqpoll" option)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.16.86.63]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone!

I've never faced this problem before but after I've recently
renewed my PC (a new MoBo and CPU) I'm now randomly getting
this kernel message after booting the PC:

[ 4684.693288] irq 18: nobody cared (try booting with the "irqpoll" option)
[ 4684.693294] Pid: 0, comm: swapper Tainted: P            2.6.37-ic #1
[ 4684.693296] Call Trace:
[ 4684.693303]  [<c129ebd9>] ? printk+0x18/0x1a
[ 4684.693309]  [<c1066637>] __report_bad_irq.clone.2+0x27/0x90
[ 4684.693314]  [<c10667ef>] note_interrupt+0x14f/0x190
[ 4684.693320]  [<c101cc72>] ? ack_apic_level+0x62/0x1b0
[ 4684.693323]  [<c1068354>] ? move_native_irq+0x14/0x50
[ 4684.693328]  [<c10672fb>] handle_fasteoi_irq+0xab/0xd0
[ 4684.693332]  [<c1067250>] ? handle_fasteoi_irq+0x0/0xd0
[ 4684.693334]  <IRQ>  [<c1004e24>] ? do_IRQ+0x44/0xc0
[ 4684.693340]  [<c1003229>] ? common_interrupt+0x29/0x30
[ 4684.693344]  [<c1003229>] ? common_interrupt+0x29/0x30
[ 4684.693348]  [<c103007b>] ? scheduler_tick+0x18b/0x220
[ 4684.693353]  [<c117553f>] ? intel_idle+0xaf/0x100
[ 4684.693357]  [<c1221c6e>] ? cpuidle_idle_call+0x6e/0xf0
[ 4684.693360]  [<c10016e6>] ? cpu_idle+0x46/0x80
[ 4684.693365]  [<c129127b>] ? rest_init+0x7b/0x80
[ 4684.693369]  [<c13986e1>] ? start_kernel+0x26e/0x274
[ 4684.693373]  [<c13981b9>] ? unknown_bootoption+0x0/0x1a3
[ 4684.693377]  [<c139808e>] ? i386_start_kernel+0x8e/0x90
[ 4684.693379] handlers:
[ 4684.693380] [<f89b4c20>] (e100_intr+0x0/0xd0 [e100])
[ 4684.693397] Disabling IRQ #18

The Internet and even kernel bugzilla are rife with reports like this
one and almost all of them are left unanswered or unresolved (for
instance see kernel bugzilla reports 15307 and 17672).

Can anyone shed light on this problem?

How one can debug/understand/eliminate it? Is it safe to use irqpoll
boot option?

Best wishes,

Artem

