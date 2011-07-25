Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1GYKCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:02:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45737 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1GYKCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:02:38 -0400
Date: Mon, 25 Jul 2011 03:02:29 -0700 (PDT)
Message-Id: <20110725.030229.1448266647053398033.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: mst@redhat.com, mashirle@us.ibm.com, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: clear tx zero-copy flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110725095711.GA30831@gondor.apana.org.au>
References: <20110725084057.GA30311@gondor.apana.org.au>
	<20110725094414.GA11776@redhat.com>
	<20110725095711.GA30831@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 25 Jul 2011 03:02:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 25 Jul 2011 17:57:11 +0800

> However, I think we should add a WARN_ON to the splice skb path
> so that should a packet find its way through a path that we haven't
> thought of then at least we'll know about it.

Good idea.
