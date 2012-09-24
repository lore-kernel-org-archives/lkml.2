Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2IXTvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:51:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2IXTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:51:50 -0400
Date: Mon, 24 Sep 2012 15:51:48 -0400 (EDT)
Message-Id: <20120924.155148.1513263823536378183.davem@davemloft.net>
To: maxin.john@gmail.com
Cc: cxzhang@watson.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: scm: moving dereference after NULL check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120923170330.GA5038@linux-3ix0.site>
References: <20120923170330.GA5038@linux-3ix0.site>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@gmail.com>
Date: Sun, 23 Sep 2012 13:03:30 -0400

> scm_destroy_cred() dereferences 'scm' before null check
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Every caller of scm_destroy() passes a non-NULL scm, so the
NULL test can be removed entirely.

I'll do this in net-next, thanks.
