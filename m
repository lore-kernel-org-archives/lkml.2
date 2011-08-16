Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1HPXgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:36:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42607 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1HPXgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:36:54 -0400
Date: Tue, 16 Aug 2011 16:30:36 -0700 (PDT)
Message-Id: <20110816.163036.838746426835627017.davem@davemloft.net>
To: lionel@mamane.lu
Cc: pekkas@netcore.fi, yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sit tunnels: propagate IPv6 transport class to IPv4
 Type of Service
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110814000438.GA30127@capsaicin.mamane.lu>
References: <20110814000438.GA30127@capsaicin.mamane.lu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 16:30:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lionel Elie Mamane <lionel@mamane.lu>
Date: Sun, 14 Aug 2011 02:04:38 +0200

> sit tunnels (IPv6 tunnel over IPv4) do not implement the "tos inherit"
> case to copy the IPv6 transport class byte from the inner packet to
> the IPv4 type of service byte in the outer packet. By contrast, ipip
> tunnels and GRE tunnels do.
> 
> This patch, adapted from the similar code in net/ipv4/ipip.c and
> net/ipv4/ip_gre.c, implements that.
> 
> This patch applies to 3.0.1, and has been tested on that version.
> 
> 
> Signed-off-by: Lionel Elie Mamane <lionel@mamane.lu>

Applied, thanks.
