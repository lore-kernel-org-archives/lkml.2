Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2F0HTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:19:13 -0400
Received: from ozlabs.org ([203.10.76.45]:39211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab2F0HTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:19:11 -0400
Message-ID: <1340781550.309.5.camel@concordia>
Subject: Re: Build regressions/improvements in v3.5-rc4
From: Michael Ellerman <michael@ellerman.id.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux-sh list <linux-sh@vger.kernel.org>
Date: Wed, 27 Jun 2012 17:19:10 +1000
In-Reply-To: <CAMuHMdXY1DFNV+jTiJkT99TbX7ZL5eEiKcG0iqZkUa8T7YZG4g@mail.gmail.com>
References: <1340740795-19603-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdXY1DFNV+jTiJkT99TbX7ZL5eEiKcG0iqZkUa8T7YZG4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 22:06 +0200, Geert Uytterhoeven wrote:
> On Tue, Jun 26, 2012 at 9:59 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.5-rc4 to v3.5-rc3[3], the summaries are:
> >  - build errors: +11/-219

> powerpc-randconfig
> 
>   + include/asm-generic/pgtable.h: error: implicit declaration of function 'BUG' [-Werror=implicit-function-declaration]:  => 56:2
>   + include/asm-generic/pgtable.h: error: implicit declaration of function 'BUG':  => 56
>   + include/linux/thread_info.h: error: implicit declaration of function 'WARN_ON':  => 129

Fixed by 09682c1dd3820445a27d32dcbeee6a6eafff3dc9 AFAICS.

cheers

