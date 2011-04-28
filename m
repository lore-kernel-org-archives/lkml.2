Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1D1QRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1D1QRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:17:00 -0400
Date: Thu, 28 Apr 2011 18:16:57 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Remis Lima Baima <remis.developer@googlemail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "'lkml'" <linux-kernel@vger.kernel.org>,
        "'linux-kbuild'" <linux-kbuild@vger.kernel.org>,
        "'linux arch'" <linux-arch@vger.kernel.org>,
        "'Guan Xuetao'" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH v5] kbuild: asm-generic support
Message-ID: <20110428161657.GA1619@sepie.suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org>
 <20110427194225.GA6551@merkur.ravnborg.org>
 <20110427194647.GA6621@merkur.ravnborg.org>
 <201104272152.37889.arnd@arndb.de>
 <20110427202949.GA8881@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427202949.GA8881@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:29:49PM +0200, Sam Ravnborg wrote:
> From 1b46234aa99f235b48dce0068fb5fb56ddf6ddab Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 22 Apr 2011 14:45:13 +0200
> Subject: [PATCH] kbuild: asm-generic support
> 
> There is an increasing amount of header files
> shared between individual architectures in asm-generic.
> To avoid a lot of dummy wrapper files that just
> include the corresponding file in asm-generic provide
> some basic support in kbuild for this.
> 
> With the following patch an architecture can maintain
> a list of files in the file arch/$(ARCH)/include/asm/Kbuild
> 
> To use a generic file just add:
> 
>         generic-y += <name-of-header-file.h>
> 
> For each file listed kbuild will generate the necessary
> wrapper in arch/$(ARCH)/include/generated/asm.
> 
> When installing userspace headers a wrapper is likewise created.
> 
> The original inspiration for this came from the unicore32
> patchset - although a different method is used.
> 
> The patch includes several improvements from Arnd Bergmann.
> Michael Marek contributed Makefile.asm-generic.
> 
> Remis Baima did an intial implementation along to achive
> the same - see https://patchwork.kernel.org/patch/13352/
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Acked-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> Tested-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Remis Lima Baima <remis.developer@googlemail.com>
> ---
> 
> Changes from v4 => v5
> - Mentioned Remis in changelog (thanks to Arnd)
> - Added "Acked-by" from Arnd

Applied to kbuild-2.6.git#kbuild, thanks a lot!

Michal
