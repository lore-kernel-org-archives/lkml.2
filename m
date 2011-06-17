Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1FQEEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:04:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47876 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1FQEEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:04:35 -0400
Date: Fri, 17 Jun 2011 00:03:23 -0400 (EDT)
Message-Id: <20110617.000323.333992491144793487.davem@davemloft.net>
To: manuel.f.zerpies@ww.stud.uni-erlangen.de
Cc: socketcan@hartkopp.net, urs.thuermann@volkswagen.de,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 03/11] net/can: use printk_ratelimited() instead of
 printk_ratelimit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <6c8d043e92e68ab304999fc1a1f7f4c7a04a818e.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
	<6c8d043e92e68ab304999fc1a1f7f4c7a04a818e.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 21:03:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
Date: Thu, 16 Jun 2011 14:08:01 +0200

> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited().
> 
> Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>

Applied.
