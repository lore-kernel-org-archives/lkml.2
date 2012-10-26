Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2JZRSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:18:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:59976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab2JZRSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:18:02 -0400
Date: Fri, 26 Oct 2012 10:16:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fix for 3.7-rc3
Message-ID: <20121026171657.GA11406@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.7-rc3

for you to fetch changes up to a4f743851f74fc3e0cc40c13082e65c24139f481:

  Revert "serial: omap: fix software flow control" (2012-10-24 11:57:21 -0700)

----------------------------------------------------------------
Serial fix for 3.7-rc3

Here is one patch, a revert of a omap serial driver patch that was causing
problems, for your 3.7-rc tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Felipe Balbi (1):
      Revert "serial: omap: fix software flow control"

 arch/arm/plat-omap/include/plat/omap-serial.h |  4 ++--
 drivers/tty/serial/omap-serial.c              | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)
