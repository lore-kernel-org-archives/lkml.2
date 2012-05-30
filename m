Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2E3Sxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:53:39 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:48761 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2E3Sxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:53:37 -0400
Message-ID: <20120530215333.32995tjzj9dr4jwo@www.81.fi>
Date: Wed, 30 May 2012 21:53:33 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org> <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
In-Reply-To: <20120530153949.GS27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andi Kleen <andi@firstfloor.org>:

>> I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
>> ciphers from the intel-aesni module get loaded whether I need them  
>> or not. As
>> Jussi stated most people using distros probably won't need the
>> serpent-avx-x86_64 module get loaded automatically, so it's  
>> probably better to
>> leave it that way.
>
> That means you got a 50% chance to use the wrong serpent.
>
> This was a continuous problem with AESNI and the accelerated CRC,
> that is why the cpuid probing was implemented.
>
> Without some form of auto probing you may as well not bother with
> the optimization.
>
> -Andi

Hm.. should not the i586/x86_64 assembler implementations of AES etc  
be autoloaded then too?

-Jussi

>
> --
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



