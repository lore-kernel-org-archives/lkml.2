Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1JVGh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 02:37:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51036 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1JVGh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 02:37:57 -0400
Message-ID: <1319265470.6180.13.camel@edumazet-laptop>
Subject: Re: Kernel panic from tg3 net driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: RongQing Li <roy.qing.li@gmail.com>, David Miller <davem@davemloft.net>,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Oct 2011 08:37:50 +0200
In-Reply-To: <CAEbykaVJneQ0ozUvYh2PRn-p_BowL4z4_4Y8EFCdO9mOsNX7OQ@mail.gmail.com>
References: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	 <20111020.155659.486754557434415381.davem@davemloft.net>
	 <1319141125.2854.14.camel@edumazet-laptop>
	 <20111020.161147.33259825921677777.davem@davemloft.net>
	 <1319141867.2854.19.camel@edumazet-laptop>
	 <CAEbykaWhh12pM2jRSzfGig=jeKhVWSdxfwuXHFvLTt14=BYTbA@mail.gmail.com>
	 <CAJFZqHzWUsP7szrjVwmW5+HWRND3R4qxWcnK=bqbsgL6F7XGeA@mail.gmail.com>
	 <CAEbykaVJneQ0ozUvYh2PRn-p_BowL4z4_4Y8EFCdO9mOsNX7OQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 22 octobre 2011 à 09:12 +0300, Ari Savolainen a écrit :
> 2011/10/21 RongQing Li <roy.qing.li@gmail.com>:
> > Hi Ari:
> >
> > Are you sure the patch is applied correctly and the log is same?
> > If the log is not same, could you paste it again.
> >
> > Thanks
> 
> Yes, I'm sure. The panic and the rcu splat are unrelated. The panic
> occurs when skb_tx_timestamp is being called after skb having been
> freed by tigon3_dma_hwbug_workaround.

OK that makes sense, thanks !

Do you plan to submit a patch, now you found the bug ?



