Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1JSHwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:52:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36922 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1JSHwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:52:39 -0400
Message-ID: <1319010739.18562.6.camel@edumazet-laptop>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga) causes
 kernel oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Date: Wed, 19 Oct 2011 09:52:19 +0200
In-Reply-To: <20111019.033052.851679720607111734.davem@davemloft.net>
References: <20111018134537.GA17055@gondor.apana.org.au>
	 <20111019.030914.218521668377472155.davem@davemloft.net>
	 <1319008713.17914.8.camel@edumazet-laptop>
	 <20111019.033052.851679720607111734.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 03:30 -0400, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 19 Oct 2011 09:18:33 +0200
> 
> > Seems fine (Maybe do the +15 in caller site ?), but we also have other
> > problematic cases, using alloc_skb() only...
> 
> Ok, which ones operate over these problematic GRE tunnels?
> 

I was more thinking of general idea to allow any device to change its
needed headroom.

For GRE tunnels, I dont think IPv6 fragmentation could be relevant,
but maybe IGMP could trigger a problem ?



