Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab1KNFJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:09:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1KNFJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:09:45 -0500
Date: Mon, 14 Nov 2011 00:09:30 -0500 (EST)
Message-Id: <20111114.000930.2208688710577745372.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, xiaosuo@gmail.com, greearb@candelatech.com,
        loke.chetan@gmail.com, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable
 from prb_setup_retire_blk_timer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:09:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 13 Nov 2011 22:55:50 +0100 (CET)

> We test for 'tx_ring' being != zero and BUG() if that's the case. So after
> that check there is no way that 'tx_ring' could be anything _but_ zero, so
> testing it again is just dead code. Once that dead code is removed, the
> 'pkc' local variable becomes entirely redundant, so remove that as well.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.
