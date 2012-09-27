Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2I0Wku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:40:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2I0Wks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:40:48 -0400
Date: Thu, 27 Sep 2012 18:40:46 -0400 (EDT)
Message-Id: <20120927.184046.860639139393284889.davem@davemloft.net>
To: wking@tremily.us
Cc: netdev@vger.kernel.org, jasowang@redhat.com, greearb@candelatech.com,
        joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8139too: add 1013:1211 PCI ID for a strange SMC1211TX.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eaafda75f4966acad08dd10e2627d7615b61206c.1348599606.git.wking@tremily.us>
References: <eaafda75f4966acad08dd10e2627d7615b61206c.1348599606.git.wking@tremily.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "W. Trevor King" <wking@tremily.us>
Date: Tue, 25 Sep 2012 16:35:54 -0400

> The FCC ID on the board is HEDEN1207DTXR01, which belongs to Accton
> Technology Corporation.  This matches the expected 1113 ID.  Perhaps
> my board just has a dying EEPROM?
> 
> Signed-off-by: W. Trevor King <wking@tremily.us>
> ---
> I'm not sure if this qualifies as a patch-able issue, but I thought
> I'd send it in in case someone else gets bitten by this.

That indeed looks like a bit flip to me, 0x1013 is Cirrus Logic who,
last time I checked, hasn't made any 8139too network cards :-)

I think I'll pass on this patch until we have someone else hit it.
