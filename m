Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2AFXMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:12:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2AFXMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:12:05 -0500
Message-ID: <4F077FA8.7060100@zytor.com>
Date: Fri, 06 Jan 2012 15:11:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/syscall changes for v3.3
References: <20120105152918.GA12838@elte.hu> <20120106230526.088cb77546022ecda34aaae5@canb.auug.org.au>
In-Reply-To: <20120106230526.088cb77546022ecda34aaae5@canb.auug.org.au>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/06/2012 04:05 AM, Stephen Rothwell wrote:
> 
> HPA has a pending fix for this patch as it causes warnings on
> PowerPC at least.  The idea was to move this include of
> asm/asm-offsets.h into asm/ftrace.h so it only affects x86.
> 

Sorry... have been in baby mode for the past week, but yes, I think it
only causes warnings and it's a trivial fix.

	-hpa
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPB3+bAAoJEL2gYIVJO6zkdxgQAIjDIV16WeaGLVSxYaxnJBi4
wbnt4oK6DRvROSNIe8D+SvzBDsyAL1bxsqVw3klgmuWudsdIx4T20ODEsEGObKOI
KKHWQSfMP2by5wRPxnTRJmFVnkOj8dMcCIcOWfAj8JzLe3fXXtuILkQ4iLfXnWuG
Q1DmaFXf0b7ZgcKDoMzBj779WhJUQ03/r7laJTgvtHeppNH8qmbeoOf2mHCs5IuO
r8EPJoAe+s1Fq+iDTPWDYrZgDIH4V3GVtd2zvlLEtgvmTwG9YNpQ7hjEX49TQnPL
oLcutQr1t35HqH7NcKhUbL3hRoIHDcZph0P412hd2nzrXS5vm4ljI0uEI9rSUThu
3NFbZykvXy+XisPNIcOfHt61QRO+igikM4wSh/eG4Qx8Fc7TyfsaLNzTrPRfq3u9
1Mu0MwJj6jlHN68142As6XdPJ9egQw/mXtA/L+DRNUSn+2gANIxoXD1KB7LnN25R
G6TIbXqtzMGlNcPEL+c93CCmRZgls4QB3jp/RfjW1OWLtgRxwOq6wPft4XK1v8aB
BchoeckiG8K6lTEfqSIHHrqas81coMfrBxehkp/vZ2Y3qmxeA0/rrmvjLD8pEk6F
OpMYdKwGMoVbeIf4nJdbefX3wOv53SLDjp4tTP6I+bmjz6/kZrKIqQwUmp/jWm+/
J2ozPxkZ8faPCNY3aqDI
=3zyX
-----END PGP SIGNATURE-----
