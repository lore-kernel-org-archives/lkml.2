Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2DMPHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:07:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49629 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2DMPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:07:46 -0400
Date: Fri, 13 Apr 2012 11:05:38 -0400 (EDT)
Message-Id: <20120413.110538.449625213257927113.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/key/af_key.c: add missing kfree_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333960870-19735-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1333960870-19735-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 08:05:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon,  9 Apr 2012 10:41:10 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> At the point of this error-handling code, alloc_skb has succeded, so free
> the resulting skb by jumping to the err label.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
