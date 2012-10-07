Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2JGPIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:08:22 -0400
Received: from mail.servus.at ([193.170.194.20]:53298 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2JGPIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:08:15 -0400
Date: Sun, 7 Oct 2012 17:07:55 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
To: linux-kernel@vger.kernel.org
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: [PATCH 0/3] Update LZO compression
Message-ID: <cover.1349621096.git.markus@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by akpm I am sending my "lzo-update" branch at

  git://github.com/markus-oberhumer/linux.git lzo-update

to lkml as a patch series created by "git format-patch -M v3.5..lzo-update".

You can also browse the branch at

  https://github.com/markus-oberhumer/linux/compare/lzo-update

and review the three patches at

  https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b734c12665a6824d219c20
  https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c8c733131915e5ae057826
  https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075cfa97e5c21f52275057f1

Share and enjoy,
Markus


Markus F.X.J. Oberhumer (3):
  lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
  lib/lzo: Update LZO compression to current upstream version
  lib/lzo: Optimize code for CPUs with inefficient unaligned access

 include/linux/lzo.h             |   15 +-
 lib/lzo/Makefile                |    2 +-
 lib/lzo/lzo1x_compress.c        |  309 +++++++++++++++++++++------------------
 lib/lzo/lzo1x_decompress.c      |  255 --------------------------------
 lib/lzo/lzo1x_decompress_safe.c |  237 ++++++++++++++++++++++++++++++
 lib/lzo/lzodefs.h               |   34 ++++-
 6 files changed, 441 insertions(+), 411 deletions(-)
 delete mode 100644 lib/lzo/lzo1x_decompress.c
 create mode 100644 lib/lzo/lzo1x_decompress_safe.c

