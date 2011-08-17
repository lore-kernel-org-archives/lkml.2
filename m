Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1HQARe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:17:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1HQARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:17:33 -0400
Date: Tue, 16 Aug 2011 17:15:25 -0700 (PDT)
Message-Id: <20110816.171525.639251389938336183.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110817100146.3b557cf815a5a2ae09bc09a7@canb.auug.org.au>
References: <20110817100146.3b557cf815a5a2ae09bc09a7@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 17:15:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Aug 2011 10:01:46 +1000

> In particular, CONFIG_TIGON3 newly depends on
> CONFIG_NET_VENDOR_BROADCOM which will no be selected when doing a
> "make oldconfig" from a working config.

When you type "make oldconfig" with an existing .config it prompts you
for those vendor guards, giving you ample opportunity to say yes to
them.
