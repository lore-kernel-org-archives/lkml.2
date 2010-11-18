Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab0KRRuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:50:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55705
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab0KRRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:50:21 -0500
Date: Thu, 18 Nov 2010 09:50:46 -0800 (PST)
Message-Id: <20101118.095046.28818361.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: justinmattock@gmail.com, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        horms@verge.net.au, netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: Re: error while building the kernel Mainline
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290102497.2781.242.camel@edumazet-laptop>
References: <1290093135.2781.167.camel@edumazet-laptop>
	<4CE561A2.2020600@gmail.com>
	<1290102497.2781.242.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 18 Nov 2010 18:48:17 +0100

> Let me guess...
> 
> net/netfilter/nf_conntrack_core is compiled as a module, and ip_vs
> statically (in vmlinux) ?
> 
> CONFIG_NF_CONNTRACK=m
> CONFIG_IP_VS=y
> 
> We probably need some Kconfig magic ;)

Randy Dunlap made a similar report today with a sample .config
that triggers the problem.

I'll look into it after lunch.
