Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2DCV6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:58:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:58:49 -0400
Date: Tue, 03 Apr 2012 17:58:37 -0400 (EDT)
Message-Id: <20120403.175837.1897033408784057713.davem@davemloft.net>
To: joe@perches.com
Cc: jdmason@kudzu.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vxge: Remove unnecessary ; in do {} while (0)
 macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333489992.2695.17.camel@joe2Laptop>
References: <1333489992.2695.17.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 14:58:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 03 Apr 2012 14:53:12 -0700

> This macro doesn't need a terminating ; so just remove it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

Longer term I'd much rather see this turned into an inline
function with proper type checking etc.
