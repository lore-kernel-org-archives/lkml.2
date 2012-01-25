Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2AYEEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:04:46 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2AYEEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:04:44 -0500
Date: Tue, 24 Jan 2012 23:02:03 -0500 (EST)
Message-Id: <20120124.230203.1478271172075708903.davem@davemloft.net>
To: joseph.glanville@orionvm.com.au
Cc: steweg@ynet.sk, eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
References: <20120123.134352.1621146585245670953.davem@davemloft.net>
	<CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
	<CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 20:02:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Date: Wed, 25 Jan 2012 14:48:37 +1100

> The reason why this patch is useful is that it stands to be the only
> true mulitpoint L2 VPN with a kernel space forwarding plane.

So what you're telling me is that I added this huge openvswitch
thing essentially for nothing?
