Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2E3Pj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:39:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2E3Pjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:39:55 -0400
Date: Wed, 30 May 2012 17:39:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Andi Kleen <andi@firstfloor.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Message-ID: <20120530153949.GS27374@one.firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun> <m2396il7xc.fsf@firstfloor.org> <20120530103025.19252e1urui8sfb4@www.81.fi> <20120530113235.GO17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530113235.GO17705@kronos.redsun>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> ciphers from the intel-aesni module get loaded whether I need them or not. As
> Jussi stated most people using distros probably won't need the
> serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> leave it that way.

That means you got a 50% chance to use the wrong serpent.

This was a continuous problem with AESNI and the accelerated CRC,
that is why the cpuid probing was implemented.

Without some form of auto probing you may as well not bother with
the optimization.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
