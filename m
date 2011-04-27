Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab1D0Tws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:52:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab1D0Twp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:52:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4] kbuild: asm-generic support
Date: Wed, 27 Apr 2011 21:52:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Michal Marek <mmarek@suse.cz>,
        "'lkml'" <linux-kernel@vger.kernel.org>,
        "'linux-kbuild'" <linux-kbuild@vger.kernel.org>,
        "'linux arch'" <linux-arch@vger.kernel.org>,
        "'Guan Xuetao'" <guanxuetao@mprc.pku.edu.cn>,
        Remis Lima Baima <remis.developer@googlemail.com>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110427194225.GA6551@merkur.ravnborg.org> <20110427194647.GA6621@merkur.ravnborg.org>
In-Reply-To: <20110427194647.GA6621@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104272152.37889.arnd@arndb.de>
X-Provags-ID: V02:K0:IDTW/vVIvgRjBrr+JuPNQWLmIPnrqjAyeOpBEViPg2J
 zeJl/yPjiaqZjtN5TNwgkbkY6AJIm6r7omBnKwG8OJR22cytjW
 c4oq1I55V1pB2l3Dw5yGRZDuYj6zsVwLQ3HU9eoOts1U2YmRzk
 S3yB6AROZVGkrIAPk0AbsjK8/MMjHjY5rZn0n/8n0H8Y0p+95x
 olWi3cgHNbH8XyJLdxjsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 21:46:47 Sam Ravnborg wrote:
> From 8546953f0c87d6b1c37c25df73511780c86ad89d Mon Sep 17 00:00:00 2001
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
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Acked-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> Tested-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I'm glad to see this finally happen.

Maybe you can mention Remis Baima in the changelog as well,
he did an earlier implementation back in the days when some
architectures were still using include/asm-${ARCH}, which IIRC
did not get merged because of the complexity associated with
that.

	Arnd
