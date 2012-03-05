Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab2CEXgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:36:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37920 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2CEXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:35:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.221.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 15:35:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.3-rc6
Message-ID: <20120305233550.GA18798@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b:

  Merge tag 'usb-3.3-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-02-22 13:00:53 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ usb-3.3-rc6

for you to fetch changes up to 71919403dc86b40fafd9400738668f96679c551b:

  Revert "powerpc/usb: fix issue of CPU halt when missing USB PHY clock" (2012-03-02 16:08:54 -0800)

----------------------------------------------------------------
USB: revert a powerpc EHCI patch

There is just one patch in here, a revert of a powerpc EHCI driver
patch that was reported to cause problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "powerpc/usb: fix issue of CPU halt when missing USB PHY clock"

 drivers/usb/host/ehci-fsl.c |   11 ++---------
 drivers/usb/host/ehci-fsl.h |    1 -
 2 files changed, 2 insertions(+), 10 deletions(-)
