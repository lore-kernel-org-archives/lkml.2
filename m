Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2DOQjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:39:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37289 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab2DOQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:39:00 -0400
Date: Sun, 15 Apr 2012 12:38:51 -0400 (EDT)
Message-Id: <20120415.123851.786816332832233291.davem@davemloft.net>
To: dbaluta@ixiacom.com
Cc: netdev@vger.kernel.org, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][trivial] ipv4: fix checkpatch errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334489681-4662-1-git-send-email-dbaluta@ixiacom.com>
References: <1334489681-4662-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 15 Apr 2012 09:38:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dbaluta@ixiacom.com
Date: Sun, 15 Apr 2012 14:34:41 +0300

> From: Daniel Baluta <dbaluta@ixiacom.com>
> 
> Fix checkpatch errors of the following type:
> 	* ERROR: "foo * bar" should be "foo *bar"
> 	* ERROR: "(foo*)" should be "(foo *)"
> 
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>

Applied, but:

> @@ -216,7 +216,7 @@ static struct rtnl_link_stats64 *ipgre_get_stats64(struct net_device *dev,
>  
>  /* Given src, dst and key, find appropriate for input tunnel. */
>  
> -static struct ip_tunnel * ipgre_tunnel_lookup(struct net_device *dev,
> +static struct ip_tunnel *ipgre_tunnel_lookup(struct net_device *dev,
>  					      __be32 remote, __be32 local,
>  					      __be32 key, __be16 gre_proto)
>  {

I had to reindent these function arguments on the lines after the one
you modified so that they continue to line up properly with the column
of the openning parenthesis on the previous line.

Do not blindly make checkpatch fixes without taking into consideration
the indentation modifications necessary in the context around your
change.
