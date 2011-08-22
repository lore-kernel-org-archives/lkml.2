Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1HVUw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:52:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1HVUw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:52:27 -0400
Date: Mon, 22 Aug 2011 13:52:00 -0700 (PDT)
Message-Id: <20110822.135200.2097710885170099050.davem@davemloft.net>
To: jj@chaosbits.net
Cc: khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH][Trivial] net/wan/hdlc_ppp: remove dead goto
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1108212337380.8097@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108130138100.7387@swampdragon.chaosbits.net>
	<20110818.220249.1523360015062657902.davem@davemloft.net>
	<alpine.LNX.2.00.1108212337380.8097@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 13:52:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 21 Aug 2011 23:38:51 +0200 (CEST)

> From: Jesper Juhl <jj@chaosbits.net>
> Subject: [PATCH] net/wan/hdlc_ppp: use break in switch
> 
> We'll either hit one of the case labels or the default in the switch
> and in all cases do we then 'goto out' and we also have a 'goto out'
> after the switch that is redundant. Change to just use break in the
> case statements and leave the 'goto out' after the lop for everyone to
> hit.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
