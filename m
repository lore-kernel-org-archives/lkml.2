Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030541Ab2CQWqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 18:46:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45224 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2CQWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 18:46:52 -0400
Date: Sat, 17 Mar 2012 15:41:06 -0700 (PDT)
Message-Id: <20120317.154106.2065585022630172500.davem@davemloft.net>
To: joe@perches.com
Cc: geoff@infradead.org, kou.ishizaki@toshiba.co.jp, jens@de.ibm.com,
        samuel@sortiz.org, wg@grandegger.com, mkl@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] drivers: net: Remove unnecessary line continuations
From: David Miller <davem@davemloft.net>
In-Reply-To: <67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
References: <1d738d4a4dd61978f969ed4a43f2dd3717f51a19.1332011552.git.joe@perches.com>
	<67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 17 Mar 2012 15:41:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 17 Mar 2012 12:14:03 -0700

> Line continuations are error prone so just remove them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
