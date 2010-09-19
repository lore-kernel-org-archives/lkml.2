Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0ISUXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:23:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57716
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab0ISUXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:23:53 -0400
Date: Sun, 19 Sep 2010 13:24:12 -0700 (PDT)
Message-Id: <20100919.132412.102552920.davem@davemloft.net>
To: bandan.das@stratus.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, herbert@gondor.hengli.com.au, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] bridge : Sanitize skb before it enters
 the IP stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100919193433.GF31036@stratus.com>
References: <20100919193433.GF31036@stratus.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bandan.das@stratus.com>
Date: Sun, 19 Sep 2010 15:34:33 -0400

> Related dicussion here : http://lkml.org/lkml/2010/9/3/16
> 
> Introduce a function br_parse_ip_options that will audit the 
> skb and possibly refill IP options before a packet enters the
> IP stack. If no options are present, the function will zero out
> the skb cb area so that it is not misinterpreted as options by some
> unsuspecting IP layer routine. If packet consistency fails, drop it.
> 
> Signed-off-by: Bandan Das <bandan.das@stratus.com>

Applied, thanks a lot!
