Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2HOJ2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:28:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53918 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab2HOJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:28:09 -0400
Date: Wed, 15 Aug 2012 11:28:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120815092804.GA14676@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120815114216.209814z4mq3hxqe8@www.81.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:42:16AM +0300, Jussi Kivilinna wrote:
> I started thinking about the performance on AMD Bulldozer.
> vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers
> on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on
> Intel sandy-bridge (where instructions have latency of 1 to 2). See:
> http://www.agner.org/optimize/instruction_tables.pdf
>
> It would be really good, if implementation could be tested on AMD CPU
> to determinate, if it causes performance regression. However I don't
> have access to machine with such CPU.

But I do. :)

And if you tell me exactly how to run the tests and on what kernel, I'll
try to do so.

HTH.

-- 
Regards/Gruss,
Boris.
