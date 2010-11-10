Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab0KJUMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:12:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43360
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab0KJUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:12:13 -0500
Date: Wed, 10 Nov 2010 12:12:37 -0800 (PST)
Message-Id: <20101110.121237.28791448.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: holt@sgi.com, akpm@linux-foundation.org, w@1wt.eu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] net: avoid limits overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289381066.2860.109.camel@edumazet-laptop>
References: <20101005.145055.63017205.davem@davemloft.net>
	<20101110061507.GF4330@sgi.com>
	<1289381066.2860.109.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 10 Nov 2010 10:24:26 +0100

> [PATCH] net: avoid limits overflow
> 
> Robin Holt tried to boot a 16TB machine and found some limits were
> reached : sysctl_tcp_mem[2], sysctl_udp_mem[2]
> 
> We can switch infrastructure to use long "instead" of "int", now
> atomic_long_t primitives are available for free.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: Robin Holt <holt@sgi.com>
> Reviewed-by: Robin Holt <holt@sgi.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied.
