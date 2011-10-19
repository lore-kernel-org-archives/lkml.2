Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1JSHcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:32:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50324 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JSHcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:32:04 -0400
Date: Wed, 19 Oct 2011 03:30:52 -0400 (EDT)
Message-Id: <20111019.033052.851679720607111734.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: herbert@gondor.hengli.com.au, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
 causes kernel oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319008713.17914.8.camel@edumazet-laptop>
References: <20111018134537.GA17055@gondor.apana.org.au>
	<20111019.030914.218521668377472155.davem@davemloft.net>
	<1319008713.17914.8.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 00:30:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 19 Oct 2011 09:18:33 +0200

> Seems fine (Maybe do the +15 in caller site ?), but we also have other
> problematic cases, using alloc_skb() only...

Ok, which ones operate over these problematic GRE tunnels?

