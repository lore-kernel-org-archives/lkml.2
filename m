Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2KPOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:19:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:47937 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2KPOTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:19:02 -0500
Date: Fri, 16 Nov 2012 06:19:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.7-rc5
Message-ID: <20121116141950.GA2175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.7-rc5

for you to fetch changes up to d38e0e3fed4f58bcddef4dc93a591dfe2f651cb0:

  Revert "Staging: Android alarm: IOCTL command encoding fix" (2012-11-13 13:04:43 -0800)

----------------------------------------------------------------
Staging tree fix for 3.7-rc5

Here is a single patch, a revert of an android driver patch, that
resolves a bug that has been reported in the Android alarm driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Colin Cross (1):
      Revert "Staging: Android alarm: IOCTL command encoding fix"

 drivers/staging/android/android_alarm.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)
