Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2A0V2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:28:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2A0V2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:28:42 -0500
Date: Fri, 27 Jan 2012 16:28:23 -0500 (EST)
Message-Id: <20120127.162823.1960229872591588915.davem@davemloft.net>
To: glommer@parallels.com
Cc: mingo@elte.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v3.3-rc1 regression] TCP: too many of orphaned sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F22D05A.8030604@parallels.com>
References: <20120127142246.GA22318@elte.hu>
	<4F22B634.2020007@parallels.com>
	<4F22D05A.8030604@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Jan 2012 13:28:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 27 Jan 2012 20:27:06 +0400

> +extern void init_tcp_mem(struct net *net);

Please name this "tcp_init_mem" or similar, keeping all TCP functions
globally exported with a "tcp_*" prefix.
