Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2KWQa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:30:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2KWQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:30:27 -0500
Date: Fri, 23 Nov 2012 08:30:25 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.7 (one more)
Message-ID: <20121123163025.GA24140@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had missed one pull request in the batch you merged yesterday. Better
keep them small and frequent at this point, so here it is.

The following changes since commit 5a903166dd31a42e39283b075cc6b9a9c079d1af:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-11-22 09:22:13 -1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to c667f757f392aa7b4d87374b2a975dce8c6186d1:

  Merge branch 'v3.7-samsung-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-11-22 20:43:37 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.7

I missed one pull request from Samsung with one fix in the previous
batch. Here it is -- a dma driver fix for an early version of silicon
that they still support.

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (1):
      ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of Exynos4210 SOC

Olof Johansson (1):
      Merge branch 'v3.7-samsung-fixes-3' of git://git.kernel.org/.../kgene/linux-samsung into fixes

 arch/arm/mach-exynos/dma.c              | 3 +++
 arch/arm/mach-exynos/include/mach/map.h | 1 +
 2 files changed, 4 insertions(+)
