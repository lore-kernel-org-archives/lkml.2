Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0IXSMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:12:03 -0400
Received: from kroah.org ([198.145.64.141]:39110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab0IXSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:11:54 -0400
Date: Fri, 24 Sep 2010 11:11:49 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fix for .36-rc6
Message-ID: <20100924181149.GB14923@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one staging driver fix for your .36-rc kernel.

It's a build-fix for the ti-st driver that a number of people have been
hitting, including some of the distros.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

This patch has been in the linux-next and mm trees for a long time.

The patch will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/ti-st/st.h      |    1 -
 drivers/staging/ti-st/st_core.c |    9 ++++-----
 drivers/staging/ti-st/st_core.h |    2 +-
 drivers/staging/ti-st/st_kim.c  |   22 +++++++++++++++++++---
 4 files changed, 24 insertions(+), 10 deletions(-)

---------------

Pavan Savoy (1):
      Staging: ti-st: remove st_get_plat_device

