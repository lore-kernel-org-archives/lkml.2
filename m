Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2HOODh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:03:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab2HOODf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:03:35 -0400
Date: Wed, 15 Aug 2012 16:03:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120815140331.GB4103@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
 <20120815140016.76673zs818g2hagw@www.81.fi>
 <20120815125220.GB4409@x1.osrc.amd.com>
 <20120815164854.11913imktb2fg90k@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120815164854.11913imktb2fg90k@www.81.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:48:54PM +0300, Jussi Kivilinna wrote:
> I posted patch that optimize twofish-avx few weeks ago:
> http://marc.info/?l=linux-crypto-vger&m=134364845024825&w=2
>
> I'd be interested to know, if this is patch helps on Bulldozer.

Sure, can you inline it here too please. The "Download message RAW" link
on marc.info gives me a diff but patch says:

patching file arch/x86/crypto/twofish-avx-x86_64-asm_64.S
patch unexpectedly ends in middle of line

Thanks.

-- 
Regards/Gruss,
Boris.
