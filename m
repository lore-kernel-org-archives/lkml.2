Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab0JTJBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:01:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36919
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab0JTJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:01:19 -0400
Date: Wed, 20 Oct 2010 02:01:42 -0700 (PDT)
Message-Id: <20101020.020142.189694307.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net - Add AF_ALG macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1P8CVt-0003Yv-Ml@gondolin.me.apana.org.au>
References: <20100907084213.GA4610@gondor.apana.org.au>
	<E1P8CVt-0003Yv-Ml@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 19 Oct 2010 21:46:01 +0800

> net - Add AF_ALG macros
> 
> This patch adds the socket family/level macros for the yet-to-be-born
> AF_ALG family.  The AF_ALG family provides the user-space interface
> for the kernel crypto API.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
