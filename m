Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2GIWYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:24:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2GIWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:24:50 -0400
Date: Mon, 09 Jul 2012 15:24:49 -0700 (PDT)
Message-Id: <20120709.152449.1208146051989927045.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: isdn@linux-pingi.de, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] drivers/isdn/mISDN/stack.c: remove invalid
 reference to list iterator variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341747464-1772-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
	<1341747464-1772-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun,  8 Jul 2012 13:37:38 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> If list_for_each_entry, etc complete a traversal of the list, the iterator
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.  The dereferences are just deleted from the
> debugging statement.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
