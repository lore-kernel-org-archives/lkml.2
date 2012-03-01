Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2CAUoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:44:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46746 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab2CAUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:44:23 -0500
Date: Thu, 01 Mar 2012 15:44:15 -0500 (EST)
Message-Id: <20120301.154415.1692328508436381200.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: javier.martinez@collabora.co.uk, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330604802.2465.43.camel@edumazet-laptop>
References: <20120228.140558.1132853996225815681.davem@davemloft.net>
	<4F4F641E.7000501@collabora.co.uk>
	<1330604802.2465.43.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Mar 2012 12:44:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 01 Mar 2012 04:26:42 -0800

> Why adding an obscure set of IPC mechanism in network tree, and not
> using (maybe extending) traditional IPC (Messages queues, semaphores,
> Shared memory, pipes, futexes, ...).

I actually don't understand why there is so much resistence to using a
real bonafide on-the-wire protocol, and that way if you ever wanted to
connect dbus instances on multiple machines or log dbus transactions
remotely for debugging, you could just do it.
