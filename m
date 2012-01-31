Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2AaQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:52:54 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AaQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:52:53 -0500
Date: Tue, 31 Jan 2012 11:50:05 -0500 (EST)
Message-Id: <20120131.115005.1292336126288944173.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v7, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <4168018.821328016111235.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <12547555.801328015432974.JavaMail.root@5-MeO-DMT.ynet.sk>
	<4168018.821328016111235.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 08:50:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Tue, 31 Jan 2012 14:21:51 +0100 (CET)

>   - neither NVGRE nor VXLAN are part of the openvswitch for now

Too bad, it means we'll have this new user API of your's so when
openvswitch does add the necessary code we CANNOT REMOVE your stuff.

I'm not applying this until you at least attempt an openvswitch
version, and that's basically the end of this discussion.
