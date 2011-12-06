Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1LFFcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:32:01 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1LFFcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:32:00 -0500
Date: Tue, 06 Dec 2011 00:31:57 -0500 (EST)
Message-Id: <20111206.003157.159978113328078893.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Silence seq_scale() unused warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323109796-31084-1-git-send-email-sboyd@codeaurora.org>
References: <1323109796-31084-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 05 Dec 2011 21:31:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Mon,  5 Dec 2011 10:29:56 -0800

> On a CONFIG_NET=y build
> 
> net/core/secure_seq.c:22: warning: 'seq_scale' defined but not
> used
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> I don't know how realistic this configuration is, but here it goes.

Just test INET all by itself, IPV6 will always need the INET
infrastructure for hash tables and inet socket management even in the
extremely unlikely event that we make ipv4 independently selectable at
some point.
