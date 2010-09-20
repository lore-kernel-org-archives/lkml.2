Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0ITXmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:42:53 -0400
Received: from kroah.org ([198.145.64.141]:42681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0ITXmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:42:51 -0400
Date: Mon, 20 Sep 2010 16:42:14 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for .36-rc6
Message-ID: <20100920234214.GC7672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two staging drivers fixes for the .36-rc2 kernel.

The batman-adv one is a revert of a broken change, and the vt6655 one is
a bugfix.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/batman-adv/hard-interface.c |   13 -------------
 drivers/staging/batman-adv/send.c           |    8 ++------
 drivers/staging/vt6655/wpactl.c             |   11 ++++++++---
 3 files changed, 10 insertions(+), 22 deletions(-)

---------------

Dan Carpenter (1):
      Staging: vt6655: fix buffer overflow

Sven Eckelmann (1):
      Revert: "Staging: batman-adv: Adding netfilter-bridge hooks"

