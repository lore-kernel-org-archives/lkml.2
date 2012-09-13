Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2IMRnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:43:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59256 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2IMRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:43:48 -0400
Date: Thu, 13 Sep 2012 10:43:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.6-rc6
Message-ID: <20120913174343.GA10816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.6-rc6

for you to fetch changes up to 60e233a56609fd963c59e99bd75c663d63fa91b6:

  kobject: fix oops with "input0: bad kobj_uevent_env content in show_uevent()" (2012-09-06 10:13:58 -0700)

----------------------------------------------------------------
Driver core fix for 3.6-rc6

Here is one fix for 3.6-rc6 for the kobject.h file.

It fixes a reported oops if CONFIG_HOTPLUG is disabled.  It's been in
the linux-next tree for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bjørn Mork (1):
      kobject: fix oops with "input0: bad kobj_uevent_env content in show_uevent()"

 include/linux/kobject.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
