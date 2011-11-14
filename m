Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1KNXne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:43:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48964 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1KNXnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:43:33 -0500
Date: Mon, 14 Nov 2011 18:43:25 -0500 (EST)
Message-Id: <20111114.184325.1962580278359413683.davem@davemloft.net>
To: jj@chaosbits.net
Cc: rmallon@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, xiaosuo@gmail.com, greearb@candelatech.com,
        loke.chetan@gmail.com, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable
 from prb_setup_retire_blk_timer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1111150034120.9919@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
	<4EC0AA31.9040403@gmail.com>
	<alpine.LNX.2.00.1111150034120.9919@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 Nov 2011 15:43:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Tue, 15 Nov 2011 00:37:33 +0100 (CET)

> David: You may want to pass on this one. I obviously didn't think it 
> through properly - sorry :-(

It's already in my tree and pushed out to kernel.org, what in the
world do you think "applied" means?
