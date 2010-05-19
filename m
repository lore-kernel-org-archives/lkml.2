Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0ESTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:42:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45170
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221Ab0ESTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:42:29 -0400
Date: Wed, 19 May 2010 12:42:37 -0700 (PDT)
Message-Id: <20100519.124237.113692015.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274267805.6930.9877.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
	<AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
	<1274267805.6930.9877.camel@macbook.infradead.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 19 May 2010 12:16:45 +0100

> On Wed, 2010-05-19 at 14:08 +0300, Pekka Enberg wrote:
>> 
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> 
>> Are you sending the patches to Linus or do you want me to pull them in
>> slab.git? 
> 
> I don't mind. Feel free to apply them to slab.git, but be aware that
> Herbert wanted to see a patch fixing sparc32 ARCH_SLAB_MINALIGN before
> the crypto one is applied.
> 
> Although arguably SLOB was broken on sparc32 even before the crypto
> patch -- so perhaps that fix shouldn't _have_ to go in first?

Don't worry about sparc, I'll take care of it side-band.
