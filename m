Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2E3VkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:40:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2E3VkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:40:12 -0400
Date: Wed, 30 May 2012 23:40:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
        Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Message-ID: <20120530214006.GZ27374@one.firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun> <m2396il7xc.fsf@firstfloor.org> <20120530103025.19252e1urui8sfb4@www.81.fi> <20120530113235.GO17705@kronos.redsun> <20120530153949.GS27374@one.firstfloor.org> <20120530212911.GA14884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530212911.GA14884@gondor.apana.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you provide an example where it doesn't work as intended?

It works for the current algorithms except serpent.

> What we could do is to use the cpuid-based probing when an algorithm
> is needed to selectively load the relevant implementations instead
> of all of them.  However, for most algorithms it won't make that
> big a difference since all the available ones will be loaded anyway.

Yes cpuid probing does that.

The only problem is just that serpent does not use cpuid probing.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
