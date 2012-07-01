Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2GAAds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 20:33:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45149 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2GAAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 20:33:47 -0400
Date: Sat, 30 Jun 2012 17:33:46 -0700 (PDT)
Message-Id: <20120630.173346.670086962166528527.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: vincent.sanders@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120630141222.60df95a5@pyramind.ukuu.org.uk>
References: <20120629234230.GA11480@kyllikki.org>
	<20120629.165023.1605284574408858612.davem@davemloft.net>
	<20120630141222.60df95a5@pyramind.ukuu.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sat, 30 Jun 2012 14:12:22 +0100

> In fact if you look up the stack you'll find a large number of multicast
> messaging systems which do reliable transport built on top of IP. In fact
> Red Hat provides a high level messaging cluster service that does exactly
> this. (as well as dbus which does it on the deskop level) plus a ton of
> stuff on top of that (JGroups etc)
> 
> Everybody at the application level has been using these 'receiver
> reliable'  multicast services for years (Websphere MQ, TIBCO, RTPGM,
> OpenPGM, MS-PGM, you name it). There are even accelerators for PGM based
> protocols in things like Cisco routers and Solarflare can do much of it
> on the card for 10Gbit.

The issue is that what to do when a receiver goes deaf is a policy
issue.
