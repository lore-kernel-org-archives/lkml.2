Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0LMR2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:28:34 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:45021 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452Ab0LMR2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:28:33 -0500
Subject: Re: [PATCH v2] avr32: Fix build failure conflicting types for
 'sys_execve'
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <201012131812.03487.PeterHuewe@gmx.de>
References: <20101209182132.GB24175@kroah.com>
	 <201012122037.59016.PeterHuewe@gmx.de>
	 <1292227973.18008.53.camel@hcegtvedt>
	 <201012131812.03487.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 13 Dec 2010 18:27:46 +0100
Message-ID: <1292261266.18008.72.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Dec 2010 17:27:50.0725 (UTC) FILETIME=[113ACF50:01CB9AEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 18:12 +0100, Peter Hüwe wrote: 
> Am Montag 13 Dezember 2010, 09:12:53 schrieb Hans-Christian Egtvedt:
> > > (but it still failed for quite a while longer due to other issues ;)
> > What other issues?
> 
> There's a linker error at the end:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> lib/lib.a(vsprintf.o): In function `resource_string':
> vsprintf.c:(.text+0x149e): relocation truncated to fit: R_AVR32_9UW_PCREL 
> against `.text'+16a8
> vsprintf.c:(.text+0x14ae): relocation truncated to fit: R_AVR32_9UW_PCREL 
> against `.text'+16ac
> 
> which seems to exist since May 26th in Linus' tree.
> See 
> http://kisskb.ellerman.id.au/kisskb/buildresult/2631302/
> http://kisskb.ellerman.id.au/kisskb/target/664/
> for more details.
> 
> Unfortunately I wasn't able to locate the offending commit using git bisect :/

Hmm, I haven't seen that, which toolchain and which configuration do you
use?

-- 
Hans-Christian Egtvedt

