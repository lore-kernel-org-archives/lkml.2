Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2E3Lg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:36:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2E3Lg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:36:58 -0400
Date: Wed, 30 May 2012 13:36:51 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Message-ID: <20120530113651.GP17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2396il7xc.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:sENFO9dMDlak4rK3MWLGdHJSR0QyuMJtofgt3ltdcdo
 bRcWcCV5YuV8mTHlnhkRALtKRaMYX2rajvQi3EXzB7oaUVQ75e
 MWXMuE+KEUSMcgri8aokr8dGCQ5daBkKQlubR5vpjy8+beWZYQ
 jiT9bFN5nUQN7wpgV7YSjy5rtM7+tTPC4i3pXtJBs3EcCSuxmM
 gK6OwbVw01JywQ+GJMBOIJo1MLDqakAG2dg17Na5bBbWhee95Y
 v1o3aG9mSpZ+dxuXGIh5nF5MnV7vbn4BIJV/ibllXDxit5z3EX
 o4KqgoZ+qJ9IybFKXRbHcZTjZXkd/kV42YLJi8PoTYu9D+DVET
 1ot8jFhe2w4ymv+hx3Sc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:27:43PM -0700, Andi Kleen wrote:
> Also drivers should never print anything when they cannot find hardware.
> Remove that printk.

I tried to be consistent with the existing ciphers in arch/x86/crypto.
In serpent_sse2_glue.c and sha1_ssse3_glue.c it is done exactly that way, so if
it will be decided to remove the printk in this patch it probably should also
be removed in the other modules.

- Johannes
