Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2JVAhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:37:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54822 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2JVAhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:37:39 -0400
Date: Sun, 21 Oct 2012 20:37:38 -0400 (EDT)
Message-Id: <20121021.203738.1974644193577737957.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] pktgen: Use ipv6_addr_any
From: David Miller <davem@davemloft.net>
In-Reply-To: <408090aa33c0ebcd8d02ce1d14b3dca590fbae62.1350618840.git.joe@perches.com>
References: <408090aa33c0ebcd8d02ce1d14b3dca590fbae62.1350618840.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 18 Oct 2012 20:55:31 -0700

> Use the standard test for a non-zero ipv6 address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
