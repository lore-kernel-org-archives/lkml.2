Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2HONtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:49:01 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:49900 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2HONs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:57 -0400
Message-ID: <20120815164854.11913imktb2fg90k@www.81.fi>
Date: Wed, 15 Aug 2012 16:48:54 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Borislav Petkov <bp@alien8.de>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
 <20120815140016.76673zs818g2hagw@www.81.fi>
 <20120815125220.GB4409@x1.osrc.amd.com>
In-Reply-To: <20120815125220.GB4409@x1.osrc.amd.com>
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

Quoting Borislav Petkov <bp@alien8.de>:

> Ok, here we go. Raw data below.

Thanks alot!

Twofish-avx appears somewhat slower than 3way, ~9% slower with 256byte  
blocks to ~3% slower with 8kb blocks.

>

<snip>

>
> Let me know if you need more tests.

I posted patch that optimize twofish-avx few weeks ago:  
http://marc.info/?l=linux-crypto-vger&m=134364845024825&w=2

I'd be interested to know, if this is patch helps on Bulldozer.

-Jussi

>
> HTH.
>
> --
> Regards/Gruss,
> Boris.
>
>



