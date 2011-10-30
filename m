Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab1J3OeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 10:34:11 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48300 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934035Ab1J3OeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 10:34:09 -0400
X-Sasl-enc: 671MbQl5Exw817Er/3aK5lWYcZs971FzAMEahZW+nEVc 1319985248
Date: Sun, 30 Oct 2011 07:34:04 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add CHAR and MISC driver maintainer entry
Message-ID: <20111030143404.GA31841@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, is the patch below ok with you?  I'll create the git tree when
3.2-rc1 is out and start adding stuff when needed for the 3.3 merge (and
for 3.2-final if there are any needed bug fixes.

thanks,

greg k-h

------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: MAINTAINERS: add CHAR and MISC driver maintainers

Yes, we are fools, but humor us.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


diff --git a/MAINTAINERS b/MAINTAINERS
index 07e5dbd..dbd65f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1751,6 +1751,14 @@ F:	include/net/cfg80211.h
 F:	net/wireless/*
 X:	net/wireless/wext*
 
+CHAR and MISC DRIVERS
+M:	Arnd Bergmann <arnd@arndb.de>
+M:	Greg Kroah-Hartman <greg@kroah.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char.git
+S:	Maintained
+F:	drivers/char/*
+F:	drivers/misc/*
+
 CHECKPATCH
 M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
