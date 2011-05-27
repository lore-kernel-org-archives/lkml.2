Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1E0Rn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:43:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1E0Rnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:43:55 -0400
Date: Fri, 27 May 2011 13:40:39 -0400 (EDT)
Message-Id: <20110527.134039.1153162956919887129.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: asharma@fb.com, maxi@daemonizer.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vorstand@stusta.mhn.de,
        Yann.Dupont@univ-nantes.fr, denys@visp.net.lb
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306466831.2543.58.camel@edumazet-laptop>
References: <1306447292.2543.32.camel@edumazet-laptop>
	<4DDEEBC5.80804@fb.com>
	<1306466831.2543.58.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 May 2011 10:40:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 27 May 2011 05:27:11 +0200

> Sure, here is a formal submission I cooked.
> 
> Thanks
> 
> [PATCH] inetpeer: fix race in unused_list manipulations

Applied, thanks Eric.
