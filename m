Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1HDHSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:18:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49213 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HDHSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:18:25 -0400
Date: Thu, 04 Aug 2011 00:13:42 -0700 (PDT)
Message-Id: <20110804.001342.605515217661107454.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, devicetree-discuss@lists.ozlabs.org,
        shawn.guo@linaro.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/of: Fix sparc build failure caused by
 of_alias_scan
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110804070033.20042.28741.stgit@ponder>
References: <20110804070033.20042.28741.stgit@ponder>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 00:13:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 04 Aug 2011 08:05:42 +0100

> Commit 750f463a, "dt: add of_alias_scan and of_alias_get_id" breaks
> platforms that don't use CONFIG_OF_FLATTREE, like SPARC and OLPC.  Fix
> it by only building it on platforms using the flat tree.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Grant this is completely bogus see my email I just posted on
linux-next.
