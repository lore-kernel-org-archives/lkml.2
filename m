Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0ERErT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:47:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62509 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0ERErR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oaFRvFejcuH1+2FDGcnoCrHwAeQrxZjJigvxSZBcx5cczY6aabj7YBUO9o386XUvbl
         5kJVeZKVbfwKBb/SDnwD/DdwVHexV5iS5+6bbP0pf3QXFqj41mIkmQwcwMFTv39Fi6ju
         In3pQTZ6gAM2DbwxJn72jlli+0z1+r0zcS8io=
Message-ID: <4BF21BD3.60901@gmail.com>
Date: Mon, 17 May 2010 21:47:15 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: senthilkumaar2021 <senthilkumaar2021@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic
References: <4BF21646.60008@gmail.com>
In-Reply-To: <4BF21646.60008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 09:23 PM, senthilkumaar2021 wrote:
> HI
>
>
> I am using iptables version 1.43 and getting the following error in
> machine while using squid in tproxy.we are using Linux machine as bridge
> too
>
> i was able to capture part of the error only please help me in solving
> the issue
>
>
> [<ffffffffa03933c2>] ? nf_nat_fn+0x138/0x14e [iptable_nat]
> [<ffffffffa0393585>] ? nf_nat_in+0x2f/0x6e [iptable_nat]
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/
> 0x2c4 [bridge]
> [<ffffffffa027edfa>] br_nf_pre_routing_finish+0x50/
> 0x2c4 [bridge]
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/
> 0x2c4 [bridge]
> [<ffffffff81339a50>] ? nf_hook_slow+0x68/0xc8
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/0x2c4 [bridge]
> [<ffffffffa027f616>] br_nf_pre_routing+0x5a8/0x5c7 [bridge]
> [<ffffffff813399ab>] nf_iterate+0x48/0x85
> [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
> [<ffffffff81339a50>] nf_hook_slow+0x68/0xc8
> [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
> [<ffffffffa027ac36>] br_handle_frame+0x1b1/0x1db [bridge]
> [<ffffffff8131d54b>] netif_receive_skb+0x316/0x434
> [<ffffffff8131dbfb>] napi_gro_receive+0x6e/0x83
> [<ffffffffa0125bfe>] e1000_receive_skb+0x5c/0x65 [e1000e]
> [<ffffffffa0125de8>] e1000_clean_rx_irq+0x1e1/0x28f [e1000e]
> [<ffffffffa012730e>] e1000_clean+0x99/0x24a [e1000e]
> [<ffffffff813bcfc5>] ? _spin_unlock_irqrestore+0x2c/0x43
> [<ffffffff8131ba62>] net_rx_action+0xb8/0x1b4
> [<ffffffff8104ed43>] __do_softirq+0x99/0x152
> [<ffffffff8101284c>] call_softirq+0x1c/0x30
> [<ffffffff81013a02>] do_softirq+0x52/0xb9
> [<ffffffff8104e969>] irq_exit+0x53/0x8d
> [<ffffffff81013d1a>] do_IRQ+0x135/0x157
> [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
> <EOI> [<ffffffff81017e20>] ? mwait_idle+0x9e/0xc7
> [<ffffffff81017e17>] ? mwait_idle+0x95/0xc7
> [<ffffffff813bfd20>] ? atomic_notifier_call_chain+0x13/0x15
> [<ffffffff810102f4>] ? enter_idle+0x27/0x2>
>
> Regards
> senthil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>


if you can.. find the last good kernel, then
do a bisect.
(if you need help doing a bisect, there's plenty
of people to help you out).

Justin P. Mattock
