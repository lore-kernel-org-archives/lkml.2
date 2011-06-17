Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab1FQEDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:03:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1FQEDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:03:40 -0400
Date: Fri, 17 Jun 2011 00:03:28 -0400 (EDT)
Message-Id: <20110617.000328.159880820812256016.davem@davemloft.net>
To: manuel.f.zerpies@ww.stud.uni-erlangen.de
Cc: andy.grover@oracle.com, rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 04/11] net/rds: use prink_ratelimited() instead of
 printk_ratelimit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <639d68afea7b4b37a5b8b228f3b15f4f81a61ed8.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
	<639d68afea7b4b37a5b8b228f3b15f4f81a61ed8.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 21:03:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
Date: Thu, 16 Jun 2011 14:09:57 +0200

> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited()
> 
> Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>

Applied.
