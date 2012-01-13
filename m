Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2AMIrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:47:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19445 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2AMIq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:46:57 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-c8-4f0fef7f7a03
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Russell King'" <rmk@arm.linux.org.uk>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Arnd Bergmann'" <arnd@arndb.de>
References: <20120113114951.7b7f131514437454e5682aa8@canb.auug.org.au>
 <033201ccd18e$a6bd5950$f4380bf0$%kim@samsung.com>
 <20120113084042.GB22472@flint.arm.linux.org.uk>
In-reply-to: <20120113084042.GB22472@flint.arm.linux.org.uk>
Subject: RE: linux-next: manual merge of the arm-current tree with Linus'	tree
Date: Fri, 13 Jan 2012 17:46:47 +0900
Message-id: <001501ccd1cf$e60451e0$b20cf5a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczRzw8tGy71mOljRcy5JVp4sC058QAABcbQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> 
> On Fri, Jan 13, 2012 at 09:59:49AM +0900, Kukjin Kim wrote:
> > Stephen Rothwell wrote:
> > >
> > > Hi Russell,
> > >
> > > Today's linux-next merge of the arm-current tree got a conflict in
> > > arch/arm/mach-exynos/common.c between (I think) commit 237c78beb8a9
> > > ("Merge branch 'depends/rmk/for-linus' into samsung/dt") from Linus'
> tree
> > > and commit 588ac27d3419 ("ARM: 7273/1: EXYNOS: Fix build error which
> was
> > > from common.c and old cpu.c") from the arm-current tree.
> > >
> > > So this arm-current fi is superceded by the merge above that is now in
> > > Linus' tree.
> > >
> > Oh, right. Now we don't need the commit 588ac27d3419.
> >
> > Russell, could you please remove it in your tree?
> 
> What the bloody hell is going on with this Samsung crap?  You send me
> fixes, you put them in the patch system, then you decide you don't want
> them?
> 
Russell,

It breaks exynos in mainline when I submitted that and sent to patch system.
Then seems to be fixed after merging arm-soc tree into mainline by Arnd's
conflict resolution.

Then you moved that into your git-curr.

> What the hell are you doing?
> 
Hmm :(

Actually, it is required when I submitted that.
But as a result, sorry for bothering...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

