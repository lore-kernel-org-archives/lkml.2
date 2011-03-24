Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1CXS6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:58:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51894
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab1CXS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:58:34 -0400
Date: Thu, 24 Mar 2011 11:59:13 -0700 (PDT)
Message-Id: <20110324.115913.13727143.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alessandro.suardi@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix fib metrics
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300986084.3747.101.camel@edumazet-laptop>
References: <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	<1300983340.3747.44.camel@edumazet-laptop>
	<1300986084.3747.101.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 24 Mar 2011 18:01:24 +0100

> [PATCH] ipv4: fix fib metrics
> 
> Alessandro Suardi reported that we could not change route metrics :
> 
> ip ro change default .... advmss 1400
> 
> This regression came with commit 9c150e82ac50 (Allocate fib metrics
> dynamically). fib_metrics is no longer an array, but a pointer to an
> array.
> 
> Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks a lot Eric.
