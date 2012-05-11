Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2EKDhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:37:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56749 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab2EKDhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:37:04 -0400
Date: Thu, 10 May 2012 23:35:54 -0400 (EDT)
Message-Id: <20120510.233554.263340913611469229.davem@davemloft.net>
To: joe@perches.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net,drivers/net: Convert compare_ether_addr_64bits
 to ether_addr_equal_64bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <acb363688c8ed729cc61e288605cdb4aa4089149.1336618708.git.joe@perches.com>
References: <cover.1336618707.git.joe@perches.com>
	<acb363688c8ed729cc61e288605cdb4aa4089149.1336618708.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 20:35:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed,  9 May 2012 20:04:04 -0700

> Use the new bool function ether_addr_equal_64bits to add
> some clarity and reduce the likelihood for misuse of
> compare_ether_addr_64bits for sorting.
> 
> Done via cocci script:
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
