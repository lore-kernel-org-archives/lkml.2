Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2GQJPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:15:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2GQJPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:15:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Tue, 17 Jul 2012 08:07:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <201207151943.08183.arnd@arndb.de> <20120717065338.GA24699@infradead.org>
In-Reply-To: <20120717065338.GA24699@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207170807.25139.arnd@arndb.de>
X-Provags-ID: V02:K0:X9YaJuy9JkRNO26DFdCDwW3dnyDzYyDSW8ZUl6jSDOH
 ZpFuBcqT4Am/nWvq7YmbmsJ7j4eiIHBC9Jkj6GX4olnZRhtBm8
 SJq5S/jZblVYNOAPCmoRK1EP7S3/n5PSQGL91u8mXh7m44hzdT
 WsdfaL9jOsaunL2LNcMC6vPRhmoN8BfWanGzz5s2gGS2YEsEo5
 EQ8RMjYtELN5hDXoz82t0Ea1J5qEkzLRvf7H5RgPwzeFOonopl
 A75gI69lUYarm82TndJQG+8EOuyVmWebI7bzLRXLaIdEtHiM0v
 xlSapAbonpvl9hcoapjd2nrtXCQLQEi75rlTrfmWJBYDcRYeqC
 3xmnlY4Fw2U/AUs+6xqY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, Christoph Hellwig wrote:
> On Sun, Jul 15, 2012 at 07:43:07PM +0000, Arnd Bergmann wrote:
> > Yes, I agree that's the best way to handle this. Compared to other
> > architectures, I think x86 is the only that allows booting either a
> > 32 or 64 bit kernel on the same system. We used to support 32 bit
> > kernels on 64 bit PowerMac, but nobody used it and we discontinued
> > it long ago. Tile 64 bit is actually incompatible with 32 bit kernels
> > at the architecture level and would require a third mode. On sparc,
> > parisc and mips, AFAIK we could support 32 bit kernels on 64 bit
> > machines, but never did.
> 
> On mips it works just fine.  On Sparc I don't think Linux ever did it,
> but Solaris did for a long time, as did (IIRC) NetBSD/OpenBSD.

Ah, I didn't know about mips doing that. I also just remembered that
s390 supports running 31 bit kernels on all 64 bit machines, but there is
no longer official support for that from IBM's side AFAIK.

I certainly expect ARM to be similar to powperpc and sparc here,
and anyone trying to submit a 32 bit kernel port for a 64 bit platform
will have a hard time arguing why that should be accepted into mainline.

	Arnd

