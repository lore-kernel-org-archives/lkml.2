Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2BATgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:36:07 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33672 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab2BATgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:36:04 -0500
Date: Wed, 01 Feb 2012 14:34:55 -0500 (EST)
Message-Id: <20120201.143455.1014458821077044311.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v7, kernel version 3.2.1] Source mode for macvlan
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <13688762.701327924297781.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <21672990.651327923923151.JavaMail.root@5-MeO-DMT.ynet.sk>
	<13688762.701327924297781.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:34:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Mon, 30 Jan 2012 12:51:37 +0100 (CET)

> V6 changes:
>  - removed ability to fill the list of macaddr per link to fix the
>    issue of netlink skb size. This can be added back by using separate
>    netlink dumper in kernel and parse inside iproute2 codes. Those codes
>    are beyond my abilities so if anyone actually need that feel free to 
>    help.

I'm not applying this patch until you add an appropriate way to query
the setting, working around the link dump SKB size issue by not providing
a way to query the information at all is not acceptable.
