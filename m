Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0DHFCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:02:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50435
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715Ab0DHFCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:02:42 -0400
Date: Wed, 07 Apr 2010 22:02:46 -0700 (PDT)
Message-Id: <20100407.220246.75372585.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ide#master] ide: clean up timed out request handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100405101313.GA17322@gondor.apana.org.au>
References: <4BB9AAB7.3020209@kernel.org>
	<20100405101313.GA17322@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 5 Apr 2010 18:13:13 +0800

> However, as this bug triggers rarely (it's a race condition between
> qemu and ide), I don't expect a negative result any time soon.
> 
> In any case, your patch looks good to me.

Tejun please formally resubmit your patch to the proper
location, linux-ide, which you failed to place on the CC:
list and therefore patchwork didn't get your patch queued
up.

Once that's done I'll toss this into ide-next-2.6

Thanks.
