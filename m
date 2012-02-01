Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2BATWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:22:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2BATWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:22:01 -0500
Date: Wed, 01 Feb 2012 14:21:56 -0500 (EST)
Message-Id: <20120201.142156.871464551711177387.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev: Convert printks to pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327882830.2652.16.camel@joe2Laptop>
References: <1327877783.2652.10.camel@joe2Laptop>
	<1327880872.2652.12.camel@joe2Laptop>
	<1327882830.2652.16.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:21:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 29 Jan 2012 16:20:30 -0800

> -		pr_warning("Number of in use tx queues changed "
> -			   "invalidating tc mappings. Priority "
> -			   "traffic classification disabled!\n");
> +		pr_warn(
> +"Number of in use tx queues changed invalidating tc mappings. "
> +"Priority traffic classification disabled!\n");

Don't do things like this.  It is never correct to un-indent subsequent
lines of a string like this.  And a line ending in "pr_whatever(" looks
terrible.
