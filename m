Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0ERE03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:26:29 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:40530 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0ERE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=HOkgNABNVU5bV5fdbpo0OUhAPiR/XtnKgVR0EUzvlrJxC9q1z3Amy38rzNnx1OZ7ni
         8LhW0rhyVAKjycD4JOASIxUFiQ3pcdL6NfB5u1bSmZaNNVae8olYmybIuTM/eRp+fYuF
         QQG523qkNMVslpnDbrbRLQ9aOCLZys9XycxR4=
Message-ID: <4BF21646.60008@gmail.com>
Date: Tue, 18 May 2010 09:53:34 +0530
From: senthilkumaar2021 <senthilkumaar2021@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI


I am using iptables version 1.43 and getting the following error in 
machine while using squid in tproxy.we are using Linux machine as bridge too

i was able to capture part of the error only please help me in solving 
the issue


 [<ffffffffa03933c2>] ? nf_nat_fn+0x138/0x14e [iptable_nat]
 [<ffffffffa0393585>] ? nf_nat_in+0x2f/0x6e [iptable_nat]
 [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/
0x2c4 [bridge]
 [<ffffffffa027edfa>] br_nf_pre_routing_finish+0x50/
0x2c4 [bridge]
 [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/
0x2c4 [bridge]
 [<ffffffff81339a50>] ? nf_hook_slow+0x68/0xc8
 [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/0x2c4 [bridge]
 [<ffffffffa027f616>] br_nf_pre_routing+0x5a8/0x5c7 [bridge]
 [<ffffffff813399ab>] nf_iterate+0x48/0x85
 [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
 [<ffffffff81339a50>] nf_hook_slow+0x68/0xc8
 [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
 [<ffffffffa027ac36>] br_handle_frame+0x1b1/0x1db [bridge]
 [<ffffffff8131d54b>] netif_receive_skb+0x316/0x434
 [<ffffffff8131dbfb>] napi_gro_receive+0x6e/0x83
 [<ffffffffa0125bfe>] e1000_receive_skb+0x5c/0x65 [e1000e]
 [<ffffffffa0125de8>] e1000_clean_rx_irq+0x1e1/0x28f [e1000e]
 [<ffffffffa012730e>] e1000_clean+0x99/0x24a [e1000e]
 [<ffffffff813bcfc5>] ? _spin_unlock_irqrestore+0x2c/0x43
 [<ffffffff8131ba62>] net_rx_action+0xb8/0x1b4
 [<ffffffff8104ed43>] __do_softirq+0x99/0x152
 [<ffffffff8101284c>] call_softirq+0x1c/0x30
 [<ffffffff81013a02>] do_softirq+0x52/0xb9
 [<ffffffff8104e969>] irq_exit+0x53/0x8d
 [<ffffffff81013d1a>] do_IRQ+0x135/0x157
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI> [<ffffffff81017e20>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81017e17>] ? mwait_idle+0x95/0xc7
 [<ffffffff813bfd20>] ? atomic_notifier_call_chain+0x13/0x15
 [<ffffffff810102f4>] ? enter_idle+0x27/0x2>

 Regards
senthil
