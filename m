Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1JSXpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:45:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34097 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1JSXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:45:20 -0400
Date: Wed, 19 Oct 2011 19:42:05 -0400 (EDT)
Message-Id: <20111019.194205.2298875957485608359.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Ian.Campbell@citrix.com, krkumar2@in.ibm.com, rusty@rustcorp.com.au,
        mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Fix guest memory leak and panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319015259.3103.3.camel@edumazet-laptop>
References: <1318944002.2657.76.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1319014511.3385.72.camel@zakaz.uk.xensource.com>
	<1319015259.3103.3.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 16:42:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 19 Oct 2011 11:07:39 +0200

>> From 369022220db31efb9c261cbabcb890a4d216a176 Mon Sep 17 00:00:00 2001
>> From: Ian Campbell <ian.campbell@citrix.com>
>> Date: Tue, 18 Oct 2011 09:59:37 +0100
>> Subject: [PATCH] net: do not take an additional reference in skb_frag_set_page
>> 
>> I audited all of the callers in the tree and only one of them (pktgen) expects
>> it to do so. Taking this reference is pretty obviously confusing and error
>> prone.
>> 
>> In particular I looked at the following commits which switched callers of
>> (__)skb_frag_set_page to the skb paged fragment api:
 ...
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
 ...
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
