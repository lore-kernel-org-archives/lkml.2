Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2BYDcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:32:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2BYDcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:32:10 -0500
Date: Fri, 24 Feb 2012 22:31:59 -0500 (EST)
Message-Id: <20120224.223159.1413120046309101641.davem@davemloft.net>
To: andrey.warkentin@gmail.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, andreiw@vmware.com
Subject: Re: [PATCH 1/2] NETPOLL: Extend rx_hook support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330136109-2518-2-git-send-email-andrey.warkentin@gmail.com>
References: <1330136109-2518-1-git-send-email-andrey.warkentin@gmail.com>
	<1330136109-2518-2-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 19:32:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Warkentin <andrey.warkentin@gmail.com>
Date: Fri, 24 Feb 2012 21:15:08 -0500

> From: Andrei Warkentin <andreiw@vmware.com>
> 
> Pass down source information to rx_hook, useful
> for accepting connections from unspecified clients.
> 
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>

This needs to be submitted to netdev for review, not linux-kernel
and your kgdb list.
