Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1CNWkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:40:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44244
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab1CNWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:40:15 -0400
Date: Mon, 14 Mar 2011 15:40:52 -0700 (PDT)
Message-Id: <20110314.154052.45887678.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ratbert.chuang@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ratbert@faraday-tech.com
Subject: Re: [PATCH net-next-2.6 v2] ftmac100: use GFP_ATOMIC allocations
 where needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300112791.3423.31.camel@edumazet-laptop>
References: <1300048193.2761.55.camel@edumazet-laptop>
	<AANLkTi=grwkfYpBFJEyQHXbFaTov5Tc+tAR2ebzw0Bht@mail.gmail.com>
	<1300112791.3423.31.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Mar 2011 15:26:31 +0100

> When running in softirq context, we should use GFP_ATOMIC allocations
> instead of GFP_KERNEL ones.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> Acked-by: Po-Yu Chuang <ratbert@faraday-tech.com>

Applied, thanks everyone.
