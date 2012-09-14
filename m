Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab2INPti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:49:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2INPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:49:36 -0400
X-AuditID: cbfee61b-b7f826d000005fb5-9f-5053520e7835
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] One more DMA-mapping fix for v3.6
Date: Fri, 14 Sep 2012 17:48:45 +0200
Message-id: <1347637725-8300-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAV2+oOAAg5MnDCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzunvGAu2slfc+d7L3sDYydbFyMkhIWAi8ejSd3YIW0ziwr31
	QHEuDiGBRYwS3f+7WCCc1UwS2+YdZgWpYhMwlOh62wXWLSJgJPH5xRVWkCJmgS4miW8X5jB2
	MXJwCAuYSvz/qAxSwyKgKrFi1m1mEJtXwF3i1+cvTBDb5CWe3u9jm8DIvYCRYRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGsA+fSe9gXNVgcYhRgINRiYc3gjUoQIg1say4MvcQowQHs5II
	r602UIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv8KfAACGB9MSS1OzU1ILUIpgsEwenVANj4Zev
	Vlt7Q4R2T/ifWLNGMqTW/rT5Y06+R2wuCm4fdvjsstBtzJnFWKZRkJK5cmfTyicF66a7/5y6
	+8J+g7+ZIht27ZG5nFdp0LnJav6umdpa584HbF8owZ1y5KPzlCnBe/qUl7yNvT1heXLvdt3X
	bqf1tSJStu74NCnZve1IYTST0+pwlm/pSizFGYmGWsxFxYkAGV/PE90BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling one more patch for ARM dma-mapping
subsystem to Linux v3.6 kernel tree. This patch fixes very subtle bug
(typical off-by-one error) which might appear in very rare
circumstances. 

The following changes since commit 55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at: 

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-3.6

for you to fetch changes up to f3d87524975f01b885fc3d009c6ab6afd0d00746:

  arm: mm: fix DMA pool affiliation check (2012-09-10 16:15:48 +0200)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Patch summary:
----------------------------------------------------------------
Thomas Petazzoni (1):
      arm: mm: fix DMA pool affiliation check

 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

