Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0FYUF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:05:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63242 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab0FYUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XMxBCwGpGR8JCyN43kE+0joWnTN2eBXJoRf17CDMZpMjsb2KKFRtCCQjywog2ZMlgw
         zD+EcRz4Y3yZDrc4qg9+rkTwOoFC/Rmos67l6NHHrCIsuLHcXWmcsz68EJMLtp8Fkm2L
         AXjmMyI/Qc7jo2wbj798PXD5et1jXQkl6BXRM=
Subject: Re: [RFC PATCH v2 4/5] skb: add tracepoints to freeing skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com, netdev <netdev@vger.kernel.org>
In-Reply-To: <4C2456DA.8030200@jp.fujitsu.com>
References: <4C2312A8.9060903@jp.fujitsu.com>
	 <4C23FF55.3090604@jp.fujitsu.com> <1277441711.2481.3.camel@edumazet-laptop>
	 <4C2456DA.8030200@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 22:05:47 +0200
Message-ID: <1277496347.2481.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 juin 2010 à 16:12 +0900, Koki Sanagi a écrit :

> > You might add a trace point to skb_free_datagram_locked() too, since it
> > contains an inlined consume_skb()
> > 
> 
> I think it is contrary.

I think you are _very_ wrong.

> skb_free_datagram_locked() contains consume_skb(), so tracepoint isn't needed.
> Because skb_free_datagram_locked() can be traced by trace_consume_skb().
> 
> 
> 

Koki, it would be good if you worked on net-next-2.6, so that my comment
applies.

Also, not sending this kind of patches on netdev is not going to help
very much.

Who is supposed to review them on lkml and Ack them ? 

Nobody.

Please build your future network related patches against net-next-2.6,
and send them to nedev and David Miller, the official network
maintainer, as stated in MAINTAINERS file.

NETWORKING [GENERAL]
M:      "David S. Miller" <davem@davemloft.net>
L:      netdev@vger.kernel.org
W:      http://www.linuxfoundation.org/en/Net
W:      http://patchwork.ozlabs.org/project/netdev/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
S:      Maintained
F:      net/
F:      include/net/
F:      include/linux/in.h
F:      include/linux/net.h
F:      include/linux/netdevice.h


