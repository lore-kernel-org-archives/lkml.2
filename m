Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1KNSl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:41:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:45756 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1KNSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:41:58 -0500
Date: Mon, 14 Nov 2011 13:41:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] SRIO powerpc compile fix.
Message-ID: <20111114184149.GA5727@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a compile regression in powerpc's serial rapidio, caused by
the module.h split.  It wasn't seen in defconfig/linux-next builds
since it isn't enabled anywhere by default.

Thanks,
Paul.


The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-linus

Liu Gang (1):
      fsl-rio: fix compile error

 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
