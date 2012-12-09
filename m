Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab2LIWQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 17:16:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2LIWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:16:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/5] asm-generic/mmu.h: Remove unused vmlist field from mm_context_t
Date: Sun, 9 Dec 2012 22:15:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org
References: <1351765467-29244-1-git-send-email-lars@metafoo.de> <201212032354.10573.arnd@arndb.de> <50BDAD3D.9020209@metafoo.de>
In-Reply-To: <50BDAD3D.9020209@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212092215.56872.arnd@arndb.de>
X-Provags-ID: V02:K0:seGo9bi6EZOLeJRNkMmNbb/HKesvPAqnr89CXgf4fjE
 bVYlA5fskiMgdw/X/AMOCYA+biTFDgZMCCKXtlKxGg/FUb58TT
 JSqhOgyHAL0DfL8OvHMaFAC/8COH9Q1z6/qWxsxz4u+IqQvGdN
 a6tRu4APYCp1AX6ucjain9uvNGDx5IywEC/xfJ4j131gEWYEk0
 dM+R4MaREs4XpQdwZse6CMxQCtCzZ3nf8ZgvAYZuWn5F0Iv+Un
 dqwAIeTWhQCk3cMcu8I5PHCXf6E3KgcjIPag4MVZCltw+8L2P0
 MY4/SqPlQuukBOSMGz9U8/9KwCPLLFniKSEYgOsHwGUWL2LLbP
 /c1SDiZrz51TvNXxhnvE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012, Lars-Peter Clausen wrote:
> On 12/04/2012 12:54 AM, Arnd Bergmann wrote:
> > On Thursday 01 November 2012, Lars-Peter Clausen wrote:
> >> Nothing is using the vmlist field in mm_context_t anymore. It has been removed
> >> from the non-generic versions over 3 years ago 8feae1311 ("NOMMU: Make VMAs per
> >> MM as for MMU-mode linux").
> >>
> >> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > 
> > Whole series:
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Do you want to include the patches in a patch set of your own, or should I put them
> > into the asm-generic tree?
> > 
> >       Arnd
> 
> Hi Arnd,
> 
> The plan was to let it go through the asm-generic tree.

Sorry for all the delay. I've applied it now.

	Arnd
