Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1JCXVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:21:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57081 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1JCXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:21:32 -0400
Date: Mon, 03 Oct 2011 19:21:29 -0400 (EDT)
Message-Id: <20111003.192129.745977451712127515.davem@davemloft.net>
To: johnmusbach1@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Handling of multiple DHCP OFFERs
From: David Miller <davem@davemloft.net>
In-Reply-To: <loom.20111004T011704-753@post.gmane.org>
References: <loom.20111004T011704-753@post.gmane.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 03 Oct 2011 16:21:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Musbach <johnmusbach1@gmail.com>
Date: Mon, 3 Oct 2011 23:18:06 +0000 (UTC)

> Hello, I am configuring a network that'll have multiple DHCP servers
> and I was wondering how Linux handles receiving multiple DHCP OFFERs?
> More specifically, how does it choose which one to prefer and how long
> will it wait for a answer from a preferred server if the other server
> answers first? Thanks.

There are multiple userspace implementations of DHCP, and the kernel
does not usually get involved at all.  You'll therefore have to ask
the folks who write and maintain the various DHCP implementations.
