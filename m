Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0ESTvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:51:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44771
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab0ESTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:51:07 -0400
Date: Wed, 19 May 2010 12:51:16 -0700 (PDT)
Message-Id: <20100519.125116.134094842.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: penberg@cs.helsinki.fi, dwmw2@infradead.org, mpm@selenic.com,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100519125903.GA27496@gondor.apana.org.au>
References: <20100519114609.GA26610@gondor.apana.org.au>
	<AANLkTiky-saTpv6Vq2ipIWC39b5eox92qQGE0QcACEBR@mail.gmail.com>
	<20100519125903.GA27496@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 19 May 2010 22:59:03 +1000

> On Wed, May 19, 2010 at 03:54:43PM +0300, Pekka Enberg wrote:
>>
>> OK, I'll pick up David's patches and just wait for sparc changes to
>> hit Linus' tree first. Herbert, do I have your ACK for the crypto
>> patches?
> 
> Of course:
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

I just sent Linus a pull request and:

Acked-by: David S. Miller <davem@davemloft.net>
