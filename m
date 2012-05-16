Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967383Ab2EPFCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:02:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966393Ab2EPFB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:01:59 -0400
Date: Wed, 16 May 2012 01:01:54 -0400 (EDT)
Message-Id: <20120516.010154.2023377176093007977.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/ipv4 and net/ipv6 logging cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1337126962.git.joe@perches.com>
References: <cover.1337126962.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 22:01:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 15 May 2012 17:11:52 -0700

> Joe Perches (2):
>   net: ipv6: Standardize prefixes for message logging
>   net: ipv4 and ipv6: Convert printk(KERN_DEBUG to pr_debug

Both applied, thanks Joe.
