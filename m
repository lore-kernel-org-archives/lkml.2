Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1JVGMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 02:12:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54999 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1JVGMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 02:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAJFZqHzWUsP7szrjVwmW5+HWRND3R4qxWcnK=bqbsgL6F7XGeA@mail.gmail.com>
References: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	<20111020.155659.486754557434415381.davem@davemloft.net>
	<1319141125.2854.14.camel@edumazet-laptop>
	<20111020.161147.33259825921677777.davem@davemloft.net>
	<1319141867.2854.19.camel@edumazet-laptop>
	<CAEbykaWhh12pM2jRSzfGig=jeKhVWSdxfwuXHFvLTt14=BYTbA@mail.gmail.com>
	<CAJFZqHzWUsP7szrjVwmW5+HWRND3R4qxWcnK=bqbsgL6F7XGeA@mail.gmail.com>
Date: Sat, 22 Oct 2011 09:12:48 +0300
Message-ID: <CAEbykaVJneQ0ozUvYh2PRn-p_BowL4z4_4Y8EFCdO9mOsNX7OQ@mail.gmail.com>
Subject: Re: Kernel panic from tg3 net driver
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: RongQing Li <roy.qing.li@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/21 RongQing Li <roy.qing.li@gmail.com>:
> Hi Ari:
>
> Are you sure the patch is applied correctly and the log is same?
> If the log is not same, could you paste it again.
>
> Thanks

Yes, I'm sure. The panic and the rcu splat are unrelated. The panic
occurs when skb_tx_timestamp is being called after skb having been
freed by tigon3_dma_hwbug_workaround.

Ari
