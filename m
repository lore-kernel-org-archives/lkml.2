Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1JTUhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:37:50 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52795 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1JTUht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:37:49 -0400
MIME-Version: 1.0
In-Reply-To: <1319141867.2854.19.camel@edumazet-laptop>
References: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	<20111020.155659.486754557434415381.davem@davemloft.net>
	<1319141125.2854.14.camel@edumazet-laptop>
	<20111020.161147.33259825921677777.davem@davemloft.net>
	<1319141867.2854.19.camel@edumazet-laptop>
Date: Thu, 20 Oct 2011 23:37:46 +0300
Message-ID: <CAEbykaWhh12pM2jRSzfGig=jeKhVWSdxfwuXHFvLTt14=BYTbA@mail.gmail.com>
Subject: Re: Kernel panic from tg3 net driver
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's right. I tried the patch and it didn't help.

Ari

2011/10/20 Eric Dumazet <eric.dumazet@gmail.com>:
> Le jeudi 20 octobre 2011 à 16:11 -0400, David Miller a écrit :
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Thu, 20 Oct 2011 22:05:25 +0200
>>
>> > And I think this was fixed yesterday ?
>> >
>> > De:         roy.qing.li@gmail.com
>> > À:  ari.m.savolainen@gmail.com, netdev@vger.kernel.org
>> > Sujet:      [PATCH net-next] neigh: fix rcu splat in neigh_update()
>> > Date:       Tue, 18 Oct 2011 16:32:42 +0800 (18/10/2011 10:32:42)
>> >
>>
>> Good catch, it seems to be this bug.
>
> Oh well, sorry, it seems it was one bug hit during bisection, but maybe
> its completely unrelated to the real problem.
>
>
>
>
