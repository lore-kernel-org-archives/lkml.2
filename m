Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1IUU5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:57:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1IUU5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:57:38 -0400
Date: Wed, 21 Sep 2011 16:55:29 -0400 (EDT)
Message-Id: <20110921.165529.1114257620345857548.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110921204545.19871.99088.stgit@ponder>
References: <20110921204545.19871.99088.stgit@ponder>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Sep 2011 13:55:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Sep 2011 14:46:54 -0600

> From: Shawn Guo <shawn.guo@linaro.org>
> 
> The patch adds function of_alias_scan to populate a global lookup
> table with the properties of 'aliases' node and function
> of_alias_get_id for drivers to find alias id from the lookup table.
> 
> v3: Split out automatic addition of aliases on id lookup so that it can be
>     debated separately from the core functionality.
> v2: - Add of_chosen/of_aliases populating and of_alias_scan() invocation
>     for OF_PROMTREE.
>     - Add locking
>     - rework parse loop
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Looks good:

Acked-by: David S. Miller <davem@davemloft.net>
