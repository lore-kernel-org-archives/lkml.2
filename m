Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0IDCKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:10:18 -0400
Received: from kroah.org ([198.145.64.141]:48486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab0IDCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:10:09 -0400
Date: Fri, 3 Sep 2010 19:09:49 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] sysfs fix for 2.6.36-git
Message-ID: <20100904020948.GC28645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a single sysfs fix for your 2.6.36-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

This patch has been in the linux-next and mm trees for a bit.

The patch will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---------------

Dan Carpenter (1):
      sysfs: checking for NULL instead of ERR_PTR

