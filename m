Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2E3Vzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:55:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48617 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab2E3Vzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:55:39 -0400
Date: Wed, 30 May 2012 23:55:37 +0200
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
Message-ID: <20120530215537.GA27374@one.firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun> <m2396il7xc.fsf@firstfloor.org> <20120530103025.19252e1urui8sfb4@www.81.fi> <20120530113235.GO17705@kronos.redsun> <20120530153949.GS27374@one.firstfloor.org> <20120530212911.GA14884@gondor.apana.org.au> <20120530214006.GZ27374@one.firstfloor.org> <20120530214448.GA15031@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530214448.GA15031@gondor.apana.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 07:44:48AM +1000, Herbert Xu wrote:
> On Wed, May 30, 2012 at 11:40:06PM +0200, Andi Kleen wrote:
> >
> > > What we could do is to use the cpuid-based probing when an algorithm
> > > is needed to selectively load the relevant implementations instead
> > > of all of them.  However, for most algorithms it won't make that
> > > big a difference since all the available ones will be loaded anyway.
> > 
> > Yes cpuid probing does that.
> 
> I was under the impression that using cpuid meant that the algorithm
> would be loaded regardless of whether it has been requested, as long
> as the cpuid matches.

It loads it always correct.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
