Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab1CWTRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:17:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46167
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458Ab1CWTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:17:53 -0400
Date: Wed, 23 Mar 2011 12:18:31 -0700 (PDT)
Message-Id: <20110323.121831.70184496.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: 2.6.39-rc: WARNING: at __ip_select_ident+0xd3/0xf0()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300873779.3063.39.camel@edumazet-laptop>
References: <AANLkTinacRCOx+z02n1OwBjGfVL5itzZs7Jqv_4PRXZK@mail.gmail.com>
	<1300873779.3063.39.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 23 Mar 2011 10:49:39 +0100

> [PATCH] ipv4: fix ip_rt_update_pmtu()
> 
> commit 2c8cec5c10bc (Cache learned PMTU information in inetpeer) added
> an extra inet_putpeer() call in ip_rt_update_pmtu().
> 
> This results in various problems, since we can free one inetpeer, while
> it is still in use.
> 
> Ref: http://www.spinics.net/lists/netdev/msg159121.html
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
