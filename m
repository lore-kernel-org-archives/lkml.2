Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0HOGuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 02:50:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45678
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab0HOGuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 02:50:16 -0400
Date: Sat, 14 Aug 2010 23:50:33 -0700 (PDT)
Message-Id: <20100814.235033.02286546.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: paulmck@linux.vnet.ibm.com, linville@tuxdriver.com, netdev@vger.kernel.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netpoll: use non-BH variant of RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100813175157.GA29586@gondor.apana.org.au>
References: <20100813143904.GA27261@gondor.apana.org.au>
	<20100813162912.GJ2511@linux.vnet.ibm.com>
	<20100813175157.GA29586@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 13 Aug 2010 13:51:57 -0400

> On Fri, Aug 13, 2010 at 09:29:12AM -0700, Paul E. McKenney wrote:
>> But all in all, mightn't it be easier to remove the checks from
>> _local_bh_enable(), and then just use rcu_read_lock_bh()?  Have those
>> checks really been that helpful in finding bugs?  ;-)
> 
> You are right.  It would be much simpler to simply have it not
> warn.

For now I'm going to assume that this is how the issue will be
addressed.
