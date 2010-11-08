Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0KHR7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:59:23 -0500
Received: from kroah.org ([198.145.64.141]:32782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0KHR6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:58:55 -0500
Date: Mon, 8 Nov 2010 09:58:32 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING build fixes for .37-rc
Message-ID: <20101108175832.GA13945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 bugfixes for the staging tree that showed up after the
.37-rc1 release due to merge issues with other trees.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git/ staging-linus

thanks,

greg k-h

--------------

 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    4 ++--
 drivers/staging/solo6x10/solo6010-v4l2-enc.c       |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2.c           |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athendpack_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athstartpack_linux.h

--------------------

Greg Kroah-Hartman (2):
      Staging: solo6x10: fix build problem
      Staging: ath6kl: remove empty files that mess with 'distclean'

Vipin Mehta (1):
      staging: ath6kl: Fixing the driver to use modified mmc_host structure

