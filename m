Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2EKDfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:35:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56714 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab2EKDfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:35:45 -0400
Date: Thu, 10 May 2012 23:35:34 -0400 (EDT)
Message-Id: <20120510.233534.836223106369679267.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 1/3] drivers/net: Convert compare_ether_addr to
 ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <7c9881a67c52c2f218480b6742155b6d6928122d.1336618708.git.joe@perches.com>
References: <cover.1336618707.git.joe@perches.com>
	<7c9881a67c52c2f218480b6742155b6d6928122d.1336618708.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 20:35:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed,  9 May 2012 20:17:46 -0700

> Use the new bool function ether_addr_equal to add
> some clarity and reduce the likelihood for misuse
> of compare_ether_addr for sorting.
> 
> Done via cocci script:
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
