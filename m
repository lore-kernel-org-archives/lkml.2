Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2IUCcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:32:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41545 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2IUCcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:32:39 -0400
Date: Thu, 20 Sep 2012 22:32:37 -0400 (EDT)
Message-Id: <20120920.223237.770883586764737313.davem@davemloft.net>
To: ecashin@coraid.com
Cc: akpm@linux-foundation.org, bhutchings@solarflare.com, jesse@nicira.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] do not disable sg when packet requires no checksum
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1348105262.git.ecashin@coraid.com>
References: <cover.1348105262.git.ecashin@coraid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ed Cashin <ecashin@coraid.com>
Date: Wed, 19 Sep 2012 18:46:07 -0700

> This two-part patchset replaces an earlier net-only patch that
> added an explicit check for the AoE protocol to harmonize_features
> in net/core/dev.c.
> 
> Following the suggestions of Ben Hutchings, this patchset makes
> the decision in the network layer protocol agnostic instead of
> using ETH_P_AOE as a special case.  It relies on fresh skbs being
> CHECKSUM_NONE but makes that explicit with an assertion.
> 
> Ed L. Cashin (2):
>   aoe: assert AoE packets marked as requiring no checksum
>   net: do not disable sg for packets requiring no checksum

Applied and queued up for -stable, thanks Ed.
