Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0F1AZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 20:25:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44174 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0F1AZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 20:25:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C27EC01.6030708@jp.fujitsu.com>
Date: Mon, 28 Jun 2010 09:25:37 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/5] skb: add tracepoints to freeing skb
References: <4C2312A8.9060903@jp.fujitsu.com>	 <4C23FF55.3090604@jp.fujitsu.com> <1277441711.2481.3.camel@edumazet-laptop>	 <4C2456DA.8030200@jp.fujitsu.com> <1277496347.2481.12.camel@edumazet-laptop>
In-Reply-To: <1277496347.2481.12.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/26 5:05), Eric Dumazet wrote:
> Le vendredi 25 juin 2010 à 16:12 +0900, Koki Sanagi a écrit :
> 
>>> You might add a trace point to skb_free_datagram_locked() too, since it
>>> contains an inlined consume_skb()
>>>
>>
>> I think it is contrary.
> 
> I think you are _very_ wrong.
> 
>> skb_free_datagram_locked() contains consume_skb(), so tracepoint isn't needed.
>> Because skb_free_datagram_locked() can be traced by trace_consume_skb().
>>
>>
>>
> 
> Koki, it would be good if you worked on net-next-2.6, so that my comment
> applies.

Yes, I am very wrong... I saw skb_free_datagram_locked() at linux-2.6.34.
It would be good to add tracepoint to it.
 
> Also, not sending this kind of patches on netdev is not going to help
> very much.
> 
> Who is supposed to review them on lkml and Ack them ? 
> 
> Nobody.
> 
> Please build your future network related patches against net-next-2.6,
> and send them to nedev and David Miller, the official network
> maintainer, as stated in MAINTAINERS file.
> 
> NETWORKING [GENERAL]
> M:      "David S. Miller" <davem@davemloft.net>
> L:      netdev@vger.kernel.org
> W:      http://www.linuxfoundation.org/en/Net
> W:      http://patchwork.ozlabs.org/project/netdev/list/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
> S:      Maintained
> F:      net/
> F:      include/net/
> F:      include/linux/in.h
> F:      include/linux/net.h
> F:      include/linux/netdevice.h

Yes, my submitting this time has many improper things(address, format and description...).
I'll check and modify them next time.

Thanks,
Koki Sanagi.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


