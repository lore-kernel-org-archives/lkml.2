Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1ISBDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 21:03:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52682 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1ISBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 21:03:16 -0400
Date: Sun, 18 Sep 2011 21:03:08 -0400 (EDT)
Message-Id: <20110918.210308.1560061605041519707.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, markus@trippelsdorf.de,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316378130.31335.32.camel@edumazet-laptop>
References: <20110918194818.GB1641@x4.trippels.de>
	<CA+55aFwmwYXzC_4q+XuEAx3ta6U-jf=NvMcAc-J+4DBxLm8Efg@mail.gmail.com>
	<1316378130.31335.32.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Sep 2011 18:03:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 18 Sep 2011 22:35:30 +0200

> [PATCH] tcp: fix build error if !CONFIG_SYN_COOKIE
> 
> commit 946cedccbd7387 (tcp: Change possible SYN flooding messages)
> added a build error if CONFIG_SYN_COOKIE=n
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
