Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1G2KAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:00:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1G2KAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:00:13 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Subject: Re: Question about "Inconsistent kallsyms data"
Date: Fri, 29 Jul 2011 12:00:07 +0200
Message-ID: <15086105.RIkTVAqRk0@flatron>
User-Agent: KMail/4.7.0  (Linux/3.0.0-gentoo; KDE/4.7.0; x86_64; ; )
In-Reply-To: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 29 of July 2011 at 10:48:46, Kukjin Kim wrote:
> Hi all,
> 
> When build with s5pc100_defconfig, happens following.
> 
> ...
> KSYM    .tmp_kallsyms2.S
> AS      .tmp_kallsyms2.o
> LD      vmlinux
> SYSMAP  System.map
> SYSMAP  .tmp_System.map
> Inconsistent kallsyms data
> This is a bug - please report about it
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2
> 
> Its HEAD is following (current latest mainline)
> (commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6)
> Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc

I can confirm that it also happens when building with s3c6400_defconfig and 
HEAD at commit 5fd00b031530cc476240f654c078c930f1dcd6ea (Merge branch 'for-
linus' of git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6).

The suggested workaround (make KALLSYMS_EXTRA_PASS=1) helps, but it is only a 
workaround and not a solution.

Any suggestions?

Best regards,
Tomasz Figa

