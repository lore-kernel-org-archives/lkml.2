Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0EYGz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:55:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54962
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab0EYGz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:55:56 -0400
Date: Mon, 24 May 2010 23:56:04 -0700 (PDT)
Message-Id: <20100524.235604.35187142.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100525051442.GA8480@gondor.apana.org.au>
References: <20100525141046.975afe1f.sfr@canb.auug.org.au>
	<20100524.215851.207470612.davem@davemloft.net>
	<20100525051442.GA8480@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 25 May 2010 15:14:42 +1000

> On Mon, May 24, 2010 at 09:58:51PM -0700, David Miller wrote:
>> 
>> Herbert, can you take a look?
> 
> Sorry, I hadn't tested the built-in case.
> 
> cls_cgroup: Fix build error when built-in
> 
> There is a typo in cgroup_cls_state when cls_cgroup is built-in.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
