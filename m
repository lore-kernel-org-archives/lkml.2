Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab0EZByI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:54:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39520
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933928Ab0EZByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:54:04 -0400
Date: Tue, 25 May 2010 18:54:14 -0700 (PDT)
Message-Id: <20100525.185414.226791146.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: build warning in Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100526015110.GA21587@gondor.apana.org.au>
References: <20100526114306.5fa6fa0e.sfr@canb.auug.org.au>
	<20100526015110.GA21587@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 26 May 2010 11:51:10 +1000

> cls_cgroup: Initialise classid when module is absent
> 
> When the cls_cgroup module is not loaded, task_cls_classid will
> return an uninitialised classid instead of zero.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
