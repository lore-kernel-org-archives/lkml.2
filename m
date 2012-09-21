Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2IUJCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:02:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35471 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2IUJCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120921162612.8e65fef4f07680d41717981c@canb.auug.org.au>
References: <20120921162612.8e65fef4f07680d41717981c@canb.auug.org.au>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 21 Sep 2012 11:02:28 +0200
Message-ID: <CAK1hOcM2-9Ret6am2+EGUC_5FE9x3c4eaPH-vgTjUujMd6LUiA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 21, 2012 at 8:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/compat_binfmt_elf.c:22:53: fatal error: asm/sigframe.h: No such file or directory
>
> Caused by commit "coredump: add a new elf note with siginfo of the
> signal".  That include file only exists on the x86 and tile architectures.
>
> I have reverted that commit (and "coredump: extend core dump note section
> to contain file names of mapped files" and
> "coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes"
> that follow it) for today.

Sorry about this. I will take a look at it.

-- 
vda
