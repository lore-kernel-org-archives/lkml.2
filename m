Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab0FPEn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:43:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44981
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623Ab0FPEny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:43:54 -0400
Date: Tue, 15 Jun 2010 21:44:06 -0700 (PDT)
Message-Id: <20100615.214406.45904170.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100616035630.GB17440@gondor.apana.org.au>
References: <20100616134848.3edd4a25.sfr@canb.auug.org.au>
	<20100616035630.GB17440@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 16 Jun 2010 13:56:30 +1000

> bridge: Add const to dummy br_netpoll_send_skb
> 
> The version of br_netpoll_send_skb used when netpoll is off is
> missing a const thus causing a warning.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied.
