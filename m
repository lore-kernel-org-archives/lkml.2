Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0FHQZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:25:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38315 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295Ab0FHQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:25:53 -0400
Subject: [RFC PATCH 0/3] kbuild: Unmet dependency warning
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 08 Jun 2010 17:25:51 +0100
Message-ID: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 16:25:51.0260 (UTC) FILETIME=[42987DC0:01CB0727]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch in this series adds a warning to the kbuild system when
options that are selected have unmet dependencies.

The subsequent patches show two simple examples that were spotted by the
first patch.

In the view of the ARM defconfig story, such patch would help with
ensuring that a platform Kconfig selects the necessary options.

Thanks.


Catalin Marinas (3):
      kbuild: Warn on selecting symbols with unmet direct dependencies
      ARM: Mark CPU_32v6K as depended on CPU_V7
      Change DEBUG_PAGEALLOC dependency on ARCH_SUPPORTS_DEBUG_PAGEALLOC


 arch/arm/mm/Kconfig      |    2 +-
 mm/Kconfig.debug         |    4 ++--
 scripts/kconfig/expr.h   |    2 ++
 scripts/kconfig/menu.c   |    5 +++++
 scripts/kconfig/symbol.c |   18 ++++++++++++++++++
 5 files changed, 28 insertions(+), 3 deletions(-)

-- 
Catalin
