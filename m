Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1G2KDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:03:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1G2KDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:03:08 -0400
Date: Fri, 29 Jul 2011 11:02:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>
Subject: Re: Question about "Inconsistent kallsyms data"
Message-ID: <20110729100241.GB25640@n2100.arm.linux.org.uk>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com> <15086105.RIkTVAqRk0@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15086105.RIkTVAqRk0@flatron>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 12:00:07PM +0200, Tomasz Figa wrote:
> Hi,
> 
> On Friday 29 of July 2011 at 10:48:46, Kukjin Kim wrote:
> > Hi all,
> > 
> > When build with s5pc100_defconfig, happens following.
> > 
> > ...
> > KSYM    .tmp_kallsyms2.S
> > AS      .tmp_kallsyms2.o
> > LD      vmlinux
> > SYSMAP  System.map
> > SYSMAP  .tmp_System.map
> > Inconsistent kallsyms data
> > This is a bug - please report about it
> > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > make[1]: *** [vmlinux] Error 1
> > make: *** [sub-make] Error 2
> > 
> > Its HEAD is following (current latest mainline)
> > (commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6)
> > Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
> 
> I can confirm that it also happens when building with s3c6400_defconfig and 
> HEAD at commit 5fd00b031530cc476240f654c078c930f1dcd6ea (Merge branch 'for-
> linus' of git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6).
> 
> The suggested workaround (make KALLSYMS_EXTRA_PASS=1) helps, but it is only a 
> workaround and not a solution.
> 
> Any suggestions?

Someone want to try bisecting to find the commit?
