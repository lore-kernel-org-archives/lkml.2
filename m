Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1I1NAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:00:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:00:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: at91 material for 3.1
Date: Wed, 28 Sep 2011 15:00:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4E82DA79.70006@atmel.com>
In-Reply-To: <4E82DA79.70006@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201109281500.30189.arnd@arndb.de>
X-Provags-ID: V02:K0:ZTp95kUxZx6xheOshj78OlZlUBQcG/0xkZX9cl79SyY
 b5OQqVyMl1WXm4vcks7RmaoUToBjr9AcKX5s0LDYF77w5l5a0X
 jBRMx944lLwZJ7jugKlm6DnctoGKOdaEX2uc4ermLbKCi5dSrz
 fYpQxGYHet08TwjkAInoCvYfYdGm0vCSpjIr0K1krx+p1la05Q
 iEBMb5kkR+MoLryRDkoe/rJnXHI62liZoBtLyKvFHs9ZH4C/4X
 dLi7ee/sTdlBLcXxjwmkB54upo4b8Kh0YEVAeHIcq/FsvVe9Do
 M9VltoYDUzzg/uZniXj3O/9jxUX1TEX8CySvPqB0+kT5KEUtCr
 ZC0TsCUqWEfoLoiXTwjk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Nicolas Ferre wrote:
> I have two little patches about Kconfig and one defconfig that are
> suitable for a 3.1 inclusion.
> 
> I wonder if you plan a pull request to Linus before 3.1-final?
> 
> If yes, would you prefer each patch in a feature branch on its own
> (at91-kconfig, at91-defconfig for instance) or a generic at91-fixes?

If you have updates that should go into the current release, they should
be bug fixes of some sort, so a single "fixes" branch is good for those.

Just send a pull request so I can add them to the common fixes branch
in the arm-soc tree. I generally send everything in there to Linus when
there is a significant amount of it, or when significant time has passed
since I sent the previous pull request or when there is something urgent
in the tree.

>From your description, it sounds like it's not urgent but I that it's
still appropriate for 3.1. Remember that when you send bug fixes I
want to have a short statement how important the patches are, roughly
listing them as one of 

1. regression: it's broken in this version without the fix, and the
   previous release was ok.
2. stable backport: the problem has been around for some time and
   the bug fix should be applied to all older kernels as well.
   (add a line "Cc: stable@kernel.org" below your Signed-off-by
   in that case)
3. bug in new code: some new feature was merged in this window
   and a bug was found in it.
4. minor bug fix: can wait for the next merge window, e.g. incorrect
   debug output or nonoptimial defconfigs.

	Arnd
