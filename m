Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1G2Mz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:55:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab1G2Mz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:55:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <rmk@arm.linux.org.uk>, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Question about "Inconsistent kallsyms data"
Date: Fri, 29 Jul 2011 14:55:01 +0200
Message-ID: <14922669.WYSjPzUBX6@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XRm47JII7a36UnrM+fGL09dLR2FRWcTKE9IR9Yprn+R
 z0u7BQzZ9iUkz5HQuXi3CVcPUCmjLsss+KsgtKhyMF8skEFOuP
 4dN89gsxruwogIKXD73YcOpaJuws8u/RtQ6ddXUM3LjRLciKSb
 hp8+YoeFVJ9NRTEho/qb6/CVTLbAbwFKYro8GTtWQSnHmLnofl
 TbP+/ftNNgsUQfj7cnSPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 July 2011 10:48:46 Kukjin Kim wrote:
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
> 
> Please kindly let me know how it should be fixed...

[Taking Michal and linux-kbuild on cc]

I've seen this before with some of my ARM randconfig builds and
spent some time debugging into it, without success.

Can you build with KALLSYMS_EXTRA_PASS=1 and send the diff between
.tmp_kallsyms2.S and .tmp_kallsyms3.S?

	Arnd
