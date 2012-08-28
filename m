Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2H1QZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:25:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab2H1QZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:25:18 -0400
Date: Tue, 28 Aug 2012 18:25:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Tilo =?utf-8?B?TcODwrxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120828162523.GA16804@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tilo =?utf-8?B?TcODwrxsbGVy?= <tilo.mueller@informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org
References: <20120822133136.GC6899@x1.osrc.amd.com>
 <20120822191516.8483.64529.stgit@localhost6.localdomain6>
 <20120823143614.GA11936@x1.osrc.amd.com>
 <20120828121743.27185dq47e19rtwk@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120828121743.27185dq47e19rtwk@www.81.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 12:17:43PM +0300, Jussi Kivilinna wrote:
> With this patch twofish-avx is faster than twofish-3way for 256, 1k
> and 8k tests.
> 
> size    old-vs-new      new-vs-3way     old-vs-3way
>         ecb-enc ecb-dec ecb-enc ecb-dec ecb-enc ecb-dec
> 256     1.10x   1.11x   1.01x   1.01x   0.92x   0.91x
> 1k      1.11x   1.12x   1.08x   1.07x   0.97x   0.96x
> 8k      1.11x   1.13x   1.10x   1.08x   0.99x   0.97x

Not bad, that's 10ish percent improvement, after all.

Thanks.

-- 
Regards/Gruss,
Boris.
