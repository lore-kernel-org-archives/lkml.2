Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2HQSK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:10:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48304 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HQSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:10:20 -0400
Date: Fri, 17 Aug 2012 11:10:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] Serial fixes for 3.6-rc3
Message-ID: <20120817181011.GA20933@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.6-rc3

for you to fetch changes up to 38f8eefccf3a23c4058a570fa2938a4f553cf8e0:

  pmac_zilog,kdb: Fix console poll hook to return instead of loop (2012-08-16 12:20:20 -0700)

----------------------------------------------------------------
TTY fixes for 3.6-rc3

Here are 4 tiny patches, each fixing a serial driver problem that people
have reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (1):
      serial: Change Kconfig entry for CLPS711X-target

Fengguang Wu (1):
      serial: ifx6x60: fix paging fault on spi_register_driver

Huang Shijie (1):
      serial: mxs-auart: fix the wrong RTS hardware flow control

Jason Wessel (1):
      pmac_zilog,kdb: Fix console poll hook to return instead of loop

 drivers/tty/serial/Kconfig      | 10 +++++-----
 drivers/tty/serial/ifx6x60.c    |  2 +-
 drivers/tty/serial/mxs-auart.c  | 14 +++++++++-----
 drivers/tty/serial/pmac_zilog.c | 12 +++++++++---
 4 files changed, 24 insertions(+), 14 deletions(-)
