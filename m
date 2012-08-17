Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2HQS1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:27:17 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:46085 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab2HQS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:27:12 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 14:27:12 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201208171820.q7HIKB34001961@clem.clem-digital.net>
Subject: 3.6-rc2 Panic -- Network interrupt
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Fri, 17 Aug 2012 14:20:11 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi: 
  Get below panic with 3.6-rc2 soon after boot (hand copy of screen).

[<c11ec9b6>] ? tcp_v4_rcv+0x626/0x740
[<C11ccecf>] ? ip_local_deliver_finish+0x6f/0x120
[<c11cce60>] ? ip_rcv+0x2b0/0x2b0
[<c11cc9c3>] ? ip_rcv_finish+0xe3/0x2d0
[<c11ae0a8>] ? __netif_receive_skb+03a8/0x4a0
[<c11ae20b>] ? process_backlog+0x6b/0x100
[<c11ae4aa>] ? net_rx_action+07a/0x100
[<c102769f>] ? __do_softirq+0x7f/0x120
[<c1027620>] ? irq_enter+0x50/0x50
<IRQ>
[<c10274b5>] ? irq_exit+0x55/0x60
[<c1003a23>] ? do_IRQ+0x43/0xa0
[<c121cc29>] ? common_interrupt+0x29/0x30
[<c1007f44>] ? default_idle+0x14/0x30
[<c1006116>] ? cpu_idle+0x26/0x40
[<c12d490a>] ? start_kernel+0x244/0x249
[<c12d4545>] ? kernel_init+0x16e/0x16e
Code: a9 ff ff e9 14 ff ff ff 90 8b 4a 48 83 e1 fe ff 41 40 89 48 78 8b 52 70 89
90 84 01 00 00 8b 51 58 85 d2 74 8c 8b 80 58 01 00 00 <8b> 52 14 89 50 68 c3 8d
b4 26 00 00 00 00 83 ec 84 0f b6 50 0e
EIP: [<d8886332>] inet6_sk_rx_dst_set+0x22/0x30 [ipv6] SS:ESP 0068:d7000dcc
CR2:0000000000010016
---[ end trace 71149a645a111f5d ]---
Kernel panic - not syncing: Fatal exception in interrupt

-- 
Pete Clements 
