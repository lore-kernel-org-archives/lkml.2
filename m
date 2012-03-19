Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2CSU6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:58:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2CSU6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:58:47 -0400
Date: Mon, 19 Mar 2012 16:58:29 -0400 (EDT)
Message-Id: <20120319.165829.2194332887711322729.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] igbvf: Use ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <49b440b7f5a9fa85ed5278e2663541283e32cad8.1332128181.git.joe@perches.com>
References: <cover.1332128181.git.joe@perches.com>
	<49b440b7f5a9fa85ed5278e2663541283e32cad8.1332128181.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 13:58:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 18 Mar 2012 20:37:58 -0700

> Remove an unnecessary #define and use memcpy
> instead of a loop to copy an ethernet address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
