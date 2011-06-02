Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1FBVo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:44:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50586 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1FBVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:44:21 -0400
Date: Thu, 02 Jun 2011 14:39:27 -0700 (PDT)
Message-Id: <20110602.143927.1073346459383432955.davem@davemloft.net>
To: pablo@netfilter.org
Cc: joe@perches.com, kaber@trash.net, andy.grover@oracle.com,
        trivial@kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [TRIVIAL PATCH next 15/15] net: Convert vmalloc/memset to
 vzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DE7A311.5000406@netfilter.org>
References: <cover.1306603968.git.joe@perches.com>
	<045996b9688bfaa2efbd8999405a67e23cd0a075.1306603968.git.joe@perches.com>
	<4DE7A311.5000406@netfilter.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 14:39:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 02 Jun 2011 16:49:53 +0200

> Are you going to take this patch? it includes one chunck which is out of
> netfilter scope.

I think the trivial folks submit these things via their own tree
and are only looking for ACKs from us.

Acked-by: David S. Miller <davem@davemloft.net>
