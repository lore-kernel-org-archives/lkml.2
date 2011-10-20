Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1JTULw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:11:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42627 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1JTULu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:11:50 -0400
Date: Thu, 20 Oct 2011 16:11:47 -0400 (EDT)
Message-Id: <20111020.161147.33259825921677777.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ari.m.savolainen@gmail.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel panic from tg3 net driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319141125.2854.14.camel@edumazet-laptop>
References: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	<20111020.155659.486754557434415381.davem@davemloft.net>
	<1319141125.2854.14.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 13:11:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 20 Oct 2011 22:05:25 +0200

> And I think this was fixed yesterday ?
> 
> De: 	roy.qing.li@gmail.com
> À: 	ari.m.savolainen@gmail.com, netdev@vger.kernel.org
> Sujet: 	[PATCH net-next] neigh: fix rcu splat in neigh_update()
> Date: 	Tue, 18 Oct 2011 16:32:42 +0800 (18/10/2011 10:32:42)
> 

Good catch, it seems to be this bug.
