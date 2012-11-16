Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2KPOTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:19:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:47961 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab2KPOTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:19:37 -0500
Date: Fri, 16 Nov 2012 06:20:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.7-rc5
Message-ID: <20121116142027.GA2216@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.7-rc5

for you to fetch changes up to 1838b8c487378c6c576029d9e0e07b5a73036bac:

  tty: serial: max310x: Add terminating entry for spi_device_id table (2012-11-14 14:49:42 -0800)

----------------------------------------------------------------
TTY fixes for 3.7-rc5

Here are two TTY driver fixes for 3.7-rc5.

They resolve a bug in the hvc driver that has been reported, and fix a
problem with the list of device ids in the max310x serial driver.

Both have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      tty: serial: max310x: Add terminating entry for spi_device_id table

Paul Mackerras (1):
      TTY: hvc_console, fix port reference count going to zero prematurely

 drivers/tty/hvc/hvc_console.c | 7 -------
 drivers/tty/serial/max310x.c  | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)
