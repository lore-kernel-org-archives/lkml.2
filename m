Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0LFU7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:59:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44524
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076Ab0LFU7s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:59:48 -0500
Date: Mon, 06 Dec 2010 13:00:15 -0800 (PST)
Message-Id: <20101206.130015.246519364.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] : __in_dev_get_rtnl() can use
 rtnl_dereference()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291203462.2856.607.camel@edumazet-laptop>
References: <1291202063-6239-1-git-send-email-amwang@redhat.com>
	<1291202476.2856.584.camel@edumazet-laptop>
	<1291203462.2856.607.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 01 Dec 2010 12:37:42 +0100

> Le mercredi 01 décembre 2010 à 12:21 +0100, Eric Dumazet a écrit :
> 
>> Same here. RTNL is held. Please use __in_dev_get_rtnl()
> 
> By the way we can use rtnl_dereference() in __in_dev_get_rtnl()
> 
> [PATCH net-next-2.6] : __in_dev_get_rtnl() can use rtnl_dereference()
> 
> If caller holds RTNL, we dont need a memory barrier
> (smp_read_barrier_depends) included in rcu_dereference().
> 
> Just use rtnl_dereference() to properly document the assertions.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
