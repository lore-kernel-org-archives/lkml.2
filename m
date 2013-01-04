Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3ADPwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:52:35 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43691 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754837Ab3ADPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:52:33 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 10:52:32 EST
Date: Fri, 4 Jan 2013 15:45:01 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 fixes for 3.8
Message-ID: <20130104154501.GG7148@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to 25c92a37a8191b5fdbbba7bdc917e14766a52461:

  arm64: Always select ARM_AMBA and GENERIC_GPIO (2013-01-04 13:20:09 +0000)

----------------------------------------------------------------
- Missing include in asm/compat.h.
- Kconfig updates.

----------------------------------------------------------------
Catalin Marinas (3):
      arm64: Include linux/ptrace.h in asm/compat.h
      arm64: Keep the ARM64 Kconfig selects sorted
      arm64: Always select ARM_AMBA and GENERIC_GPIO

 arch/arm64/Kconfig              | 6 +++++-
 arch/arm64/include/asm/compat.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)
