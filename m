Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1DDM7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:59:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1DDM7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:59:38 -0400
Date: Mon, 4 Apr 2011 14:59:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andreas Mohr <andi@lisas.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: [PATCH] eradicate bashisms in scripts/patch-kernel
Message-ID: <20110404125934.GA14828@sepie.suse.cz>
References: <20071101160857.6e877307.rdunlap@xenotime.net>
 <20071102020118.GA13852@gondor.apana.org.au>
 <20071102200935.GA14153@rhlx01.hs-esslingen.de>
 <20071102131707.6023a5b7.rdunlap@xenotime.net>
 <20071105195827.GA24117@rhlx01.hs-esslingen.de>
 <20071114144627.8628f2dd.rdunlap@xenotime.net>
 <20071117163327.GA4296@rhlx01.hs-esslingen.de>
 <20071117172816.GC7213@uranus.ravnborg.org>
 <20071117205125.GA26425@rhlx01.hs-esslingen.de>
 <20110403185828.GA4561@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403185828.GA4561@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 08:58:28PM +0200, Andreas Mohr wrote:
> Silence a remaining annoying (or worse, irritating - "is my entire patched tree
> broken now!?") bashism-related message that occurs when /bin/sh is configured
> to instead deploy dash, a POSIX-compliant shell, as is the pretty much
> standard case on e.g. Debian.
> 
> # linux-2.6.38.patch-kernel_test/scripts/patch-kernel linux-2.6.38.patch-kernel_test patch-2.6
> Current kernel version is 2.6.38 ( Flesh-Eating Bats with Fangs)
> ===>  linux-2.6.38.patch-kernel_test/scripts/patch-kernel: line 253: [: =: unary operator expected  <===
> cannot find patch file: patch-2.6.39
> 
> Signed-off-by: Andreas Mohr <andi@lisas.de>

Applied to kbuild-2.6.git#misc, thanks.

Michal
