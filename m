Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2LMSkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:40:46 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50698 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab2LMSkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:40:45 -0500
Date: Thu, 13 Dec 2012 19:40:39 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UIO changes for v3.8
Message-ID: <20121213184038.GJ4261@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
my new UIO tree is based on your current char-misc tree. Please pull the
following two patches.

Thanks,
Hans

The following changes since commit 1ebaf4f4e6912199f8a4e30ba3ab55da2b71bcdf:

  Merge branch 'x86-timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-12-11 20:01:33 -0800)

are available in the git repository at:


  git://hansjkoch.de:/home/repos/git/char-misc.git uio-devel

for you to fetch changes up to d91796fe825b7ebd8ed4150c6886faeb7c3982b1:

  uio: fix possible memory leak in uio.c (2012-12-13 18:55:59 +0100)

----------------------------------------------------------------
Cong Ding (1):
      uio: fix possible memory leak in uio.c

Hans J. Koch (1):
      uio: Fix warning: 'ret' might be used uninitialized

 drivers/uio/uio.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)
