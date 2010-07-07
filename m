Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0GGVp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:45:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40287
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757825Ab0GGVp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:45:57 -0400
Date: Wed, 07 Jul 2010 14:46:11 -0700 (PDT)
Message-Id: <20100707.144611.63043873.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: gjin@ubicom.com, shemminger@vyatta.com, skavy@ubicom.com,
       linux-kernel@vger.kernel.org, gren@ubicom.com, msezgin@ubicom.com,
       silgen@ubicom.com, netdev@vger.kernel.org
Subject: Re: Possible bug in net/ipv4/route.c?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100706072928.GB14612@gondor.apana.org.au>
References: <20100706002813.GA11194@gondor.apana.org.au>
	<CB2DD11991B27C4F99935E6229450D3203950BE5@STORK.scenix.com>
	<20100706072928.GB14612@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 6 Jul 2010 15:29:28 +0800

> bridge: Clear IPCB before possible entry into IP stack
> 
> The bridge protocol lives dangerously by having incestuous relations
> with the IP stack.  In this instance an abomination has been created
> where a bogus IPCB area from a bridged packet leads to a crash in
> the IP stack because it's interpreted as IP options.
> 
> This patch papers over the problem by clearing the IPCB area in that
> particular spot.  To fix this properly we'd also need to parse any
> IP options if present but I'm way too lazy for that.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks a lot!
