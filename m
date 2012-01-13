Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2AMBAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:00:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56006 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:00:01 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-65-4f0f820841d2
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Russell King'" <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>
References: <20120113114951.7b7f131514437454e5682aa8@canb.auug.org.au>
In-reply-to: <20120113114951.7b7f131514437454e5682aa8@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the arm-current tree with Linus' tree
Date: Fri, 13 Jan 2012 09:59:49 +0900
Message-id: <033201ccd18e$a6bd5950$f4380bf0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczRjUoPvLAHVOVmRMKCE3uIXx4yWgAARE4w
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Russell,
> 
> Today's linux-next merge of the arm-current tree got a conflict in
> arch/arm/mach-exynos/common.c between (I think) commit 237c78beb8a9
> ("Merge branch 'depends/rmk/for-linus' into samsung/dt") from Linus' tree
> and commit 588ac27d3419 ("ARM: 7273/1: EXYNOS: Fix build error which was
> from common.c and old cpu.c") from the arm-current tree.
> 
> So this arm-current fi is superceded by the merge above that is now in
> Linus' tree.
> 
Oh, right. Now we don't need the commit 588ac27d3419.

Russell, could you please remove it in your tree?

> I fixed it up by ignoring the arm-current version.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

