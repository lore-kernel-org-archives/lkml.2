Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2AZCjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:39:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2AZCjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:39:07 -0500
Date: Wed, 25 Jan 2012 21:38:02 -0500 (EST)
Message-Id: <20120125.213802.119259327303074622.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] Source mode for macvlan
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <32686570.751327481334943.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <25353423.731327481250682.JavaMail.root@5-MeO-DMT.ynet.sk>
	<32686570.751327481334943.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Jan 2012 18:38:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 09:48:54 +0100 (CET)

> +		if (vlan->mode == MACVLAN_MODE_SOURCE &&
> +			vlan->mode != nla_get_u32(data[IFLA_MACVLAN_MODE]))
 ...
> +	if (data && data[IFLA_MACVLAN_MACADDR_MODE] &&
> +		data[IFLA_MACVLAN_MACADDR]) {
 ...
> +				return macvlan_hash_add_sources(vlan,
> +					nla_data(data[IFLA_MACVLAN_MACADDR]));
 ...
> +			hlist_for_each_entry_rcu(list, n,
> +				&vlan->port->vlan_source_hash[i], hlist) {
 ...
> +			hlist_for_each_entry_rcu(list, n,
> +				&vlan->port->vlan_source_hash[i], hlist) {

Line things up on subsequent lines to the column right after the
openning parenthesis on the previous line.

If things are indented too deeply, you need to write helper functions.
