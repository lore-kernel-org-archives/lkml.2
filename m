Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2LTAPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:15:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51135 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2LTAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:15:26 -0500
Date: Wed, 19 Dec 2012 16:15:25 -0800 (PST)
Message-Id: <20121219.161525.153169039035687883.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc AES/DES/CAMELLIA crypto bug fixes
as well as an addition of a pte_accessible() define for sparc64
and a hugetlb fix from Dave Kleikamp.

Thanks.

The following changes since commit 31564cbd77baa88405862d4aa0d00893ab1d8cb7:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2012-12-18 12:46:37 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to 62ba63dc892cf836ecb9ce4fdb7644d45c95070b:

  sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in CAMELLIA code. (2012-12-19 15:44:31 -0800)

----------------------------------------------------------------
Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David S. Miller (7):
      sparc64: Define pte_accessible()
      sparc64: Fix unrolled AES 256-bit key loops.
      sparc64: Fix AES ctr mode block size.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in AES code.
      sparc64: Fix ECB looping constructs in AES code.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in DES code.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in CAMELLIA code.

 arch/sparc/crypto/aes_asm.S         | 20 ++++++++++++++------
 arch/sparc/crypto/aes_glue.c        | 31 ++++++++++++++++++++++++++++---
 arch/sparc/crypto/camellia_glue.c   |  3 +++
 arch/sparc/crypto/des_asm.S         |  1 +
 arch/sparc/crypto/des_glue.c        |  6 ++++++
 arch/sparc/include/asm/hugetlb.h    | 10 ++++++++--
 arch/sparc/include/asm/pgtable_64.h |  8 +++++++-
 7 files changed, 67 insertions(+), 12 deletions(-)
