Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2IERJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:09:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42767 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab2IERJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:09:13 -0400
Date: Wed, 05 Sep 2012 13:09:11 -0400 (EDT)
Message-Id: <20120905.130911.1579305809056694360.davem@davemloft.net>
To: claudiu.manoil@freescale.com
Cc: chikazawa.akifu@jp.fujitsu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: when the MTU interface is modified, the promiscuous mode is
 reset in gianfar driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <504757AC.90007@freescale.com>
References: <201208270838.AA02326@VF09040P.jp.fujitsu.com>
	<20120903.155332.1814926007061594344.davem@davemloft.net>
	<504757AC.90007@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@freescale.com>
Date: Wed, 5 Sep 2012 16:46:20 +0300

> I don't see how the promisc mode would be reset by changing the
> mtu. Maybe more details on the issue reproduction would help (or
> maybe a usecase involving multicast settings?)

Agreed, I can't see how this problem is even possible either.
