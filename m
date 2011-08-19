Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1HSFDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:03:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58477 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1HSFDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:03:08 -0400
Date: Thu, 18 Aug 2011 22:02:49 -0700 (PDT)
Message-Id: <20110818.220249.1523360015062657902.davem@davemloft.net>
To: jj@chaosbits.net
Cc: khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH][Trivial] net/wan/hdlc_ppp: remove dead goto
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1108130138100.7387@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108130138100.7387@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 22:02:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 13 Aug 2011 01:39:43 +0200 (CEST)

> From: Jesper Juhl <jj@chaosbits.net>
> 
> We'll either hit one of the case labels or the default in the switch
> and in all cases do we then 'goto out', so having 'goto out' right
> after the switch is pointless as we can never hit it - remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Probably a lot cleaner to use break statements in the switch() statement
and keep this goto in place.

That's more straightforward control flow than what this thing is doing.
