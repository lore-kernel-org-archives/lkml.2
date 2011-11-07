Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1KGMYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:24:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:2751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1KGMYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:24:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,469,1315206000"; 
   d="scan'208";a="71337848"
Date: Mon, 7 Nov 2011 20:24:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: [GIT PULL] fix uninitialized task_ratelimit that impacts tracing
Message-ID: <20111107122401.GA15421@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 31555213f03bca37d2c02e10946296052f4ecfcd:

  Revert "hvc_console: display printk messages on console." (2011-11-06 22:22:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git urgent-for-linus

Wu Fengguang (1):
      writeback: fix uninitialized task_ratelimit

 mm/page-writeback.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Thanks,
Fengguang

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Commit 3a73dbbc9bb3fc8594cd67af4db6c563175dfddb
from git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOt7+XAAoJECvKgwp+S8Ja/8wP/3Nhja3/uVOwcNYbAqc4e4uI
nuz67xLXaUleCHRFnFjmvm1SkGtzTFPQF593xu8SRCFeRUS0JCV9NGB0CObWPv4Z
2FQ00m0gAKbI0paYoBehav+KOnY8Jq3Ro1Ldykb8ArHzwJlLfHojlhzLmmLKRYuV
DTajFA0RKnCIWUQOPbgBF/aSeJS5GYu+Ou+1eSTTnJsofvYptEtbdduBfnCItJLE
uGj4VrfbvH/NcXodUXkXCk1cD63tJ564pOp5zXwbj7clnB3J5xcEOJF375dPJnrm
2qVBCiQRISwanrwgFJqY/td8O0ZiIC5ksKHTtb9tQKtxtOYrhRXNm5UYmTlEvmtK
9lKv9n7EGNJaJ7Hf1Phg4OAShIdkGwP1er9uLd1bTDafQ1MmfRxcfbFnOidbXQkw
zcz2KoFQhk5vW8F+N0xTjR3ip/L9UlOtkgC+LlZPmNo6gzawI4M+b9LdRVEynbiA
9qQR2mUYnSkTz5wUjfGZQe0W/tQ3JROZwCOnll8OysX5vgkWvbBokEK5cSKOffIC
TfaiNzYSh5EiqIPL5qahuYqMSWpXs254qnEs3oW0RHbV4KPNyqdKr+yYZeCaGJBG
YnRLACaZA9A2rHeH4CiAdShViPFB0NYRfc1G+s3D3vLZUeJUZGgN8nGUgUltCN1/
A0+QUxt24rA0cWqE/FEK
=AsO6
-----END PGP SIGNATURE-----
