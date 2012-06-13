Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2FMBwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:52:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2FMBwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:52:22 -0400
Date: Tue, 12 Jun 2012 18:52:20 -0700 (PDT)
Message-Id: <20120612.185220.1209592106225618525.davem@davemloft.net>
To: michel@digirati.com.br
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        edumazet@google.com, jpirko@redhat.com, mirq-linux@rere.qmqm.pl,
        bhutchings@solarflare.com
Subject: Re: [PATCH 1/1] net-next: add dev_loopback_xmit() to avoid
 duplicate code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339532195.2701.8.camel@Thor>
References: <1339532195.2701.8.camel@Thor>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Machado <michel@digirati.com.br>
Date: Tue, 12 Jun 2012 16:16:35 -0400

> Add dev_loopback_xmit() in order to deduplicate functions
> ip_dev_loopback_xmit() (in net/ipv4/ip_output.c) and
> ip6_dev_loopback_xmit() (in net/ipv6/ip6_output.c).
> 
> I was about to reinvent the wheel when I noticed that
> ip_dev_loopback_xmit() and ip6_dev_loopback_xmit() do exactly what I
> need and are not IP-only functions, but they were not available to reuse
> elsewhere.
> 
> ip6_dev_loopback_xmit() does not have line "skb_dst_force(skb);", but I
> understand that this is harmless, and should be in dev_loopback_xmit().
> 
> Signed-off-by: Michel Machado <michel@digirati.com.br>

Applied.
