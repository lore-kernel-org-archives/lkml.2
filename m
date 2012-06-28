Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2F1IU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:20:26 -0400
Received: from linux-sh.org ([111.68.239.195]:50621 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2F1IUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:20:23 -0400
Date: Thu, 28 Jun 2012 17:20:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: Build regressions/improvements in v3.5-rc4
Message-ID: <20120628082009.GC21764@linux-sh.org>
References: <1340740795-19603-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXY1DFNV+jTiJkT99TbX7ZL5eEiKcG0iqZkUa8T7YZG4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXY1DFNV+jTiJkT99TbX7ZL5eEiKcG0iqZkUa8T7YZG4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:06:27PM +0200, Geert Uytterhoeven wrote:
> On Tue, Jun 26, 2012 at 9:59 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.5-rc4 to v3.5-rc3[3], the summaries are:
> > ??- build errors: +11/-219
> 
> 11 regressions:
>   + arch/sh/include/asm/fixmap.h: error: implicit declaration of
> function 'BUG_ON' [-Werror=implicit-function-declaration]:  => 133:2
>   + arch/sh/include/asm/thread_info.h: error: implicit declaration of
> function 'WARN_ON' [-Werror=implicit-function-declaration]:  => 172:2
>   + include/linux/huge_mm.h: error: implicit declaration of function
> 'BUG' [-Werror=implicit-function-declaration]:  => 185:2
> 
> shmin_defconfig, se7712_defconfig, se7721_defconfig, sh-allnoconfig
> 
I'm unable to reproduce any of these, is there some specific compiler
version or warning flag configuration I'm supposed to be using? I'm
building with 4.5.1 at the moment.
