Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2ETILI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 04:11:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55874 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2ETIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 04:10:02 -0400
Date: Sun, 20 May 2012 04:07:20 -0400 (EDT)
Message-Id: <20120520.040720.43599161769776729.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4: replace simple_strtoul with kstrtoul
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337472798-18913-1-git-send-email-eldad@fogrefinery.com>
References: <1337472798-18913-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 May 2012 01:07:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun, 20 May 2012 02:13:18 +0200

> Replace simple_strtoul with kstrtoul in three similar occurrences, all setup
> handlers:
> * route.c: set_rhash_entries
> * tcp.c: set_thash_entries
> * udp.c: set_uhash_entries
> 
> Also check if the conversion failed.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied.
