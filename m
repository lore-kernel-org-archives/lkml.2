Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2GSOWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:22:31 -0400
Received: from smtp13.ono.com ([62.42.230.16]:58441 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145Ab2GSOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:22:28 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 10:22:28 EDT
Date: Thu, 19 Jul 2012 16:16:55 +0200
From: Guillem Jover <guillem@hadrons.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120719141655.GA13262@gaara.hadrons.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207071927.13135.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 19:27:12 +0000, Arnd Bergmann wrote:
> On Saturday 07 July 2012, Olof Johansson wrote:
> > > ARM introduced AArch64 as part of the ARMv8 architecture
> > 
> > With the risk of bikeshedding here, but I find the name awkward. How
> > about just naming the arch port arm64 instead? It's considerably more
> > descriptive in the context of the kernel.  For reference, we didn't
> > name ppc64, nor powerpc, after what the IBM/power.org marketing people
> > were currently calling the architecture at the time either.
> 
> I agree the name sucks, and I'd much prefer to just call it arm64
> as well. The main advantage of the aarch64 name is that it's the
> same as the identifier in the elf triplet, and it makes sense to
> keep the same name for all places where we need to identify the
> architecture. This also includes the rpm and dpkg architecture names,
> and the string returned by the uname syscall. If everything else
> is aarch64, we should use that in the kernel directory too, but
> if everyone calls it arm64 anyway, we should probably use that name
> for as many things as possible.

FWIW the dpkg architecture name will be arm64:

<http://anonscm.debian.org/gitweb/?p=dpkg/dpkg.git;a=commitdiff;h=7786b93>

And I'd be happy to change the GNU triplet match in dpkg, if someone
considered trying to get it renamed to something less unfortunate.

thanks,
guillem
