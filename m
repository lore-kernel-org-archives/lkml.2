Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2DTRVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:21:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab2DTRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:21:31 -0400
Date: Fri, 20 Apr 2012 10:21:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.4-rc4
Message-ID: <20120420172127.GB21573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.4-rc4

for you to fetch changes up to d3a7b83f865b46bb7b5e1ed18a129ce1af349db4:

  drivers/tty/amiserial.c: add missing tty_unlock (2012-04-19 19:15:35 -0700)

----------------------------------------------------------------
TTY fixes for 3.4-rc4

Here are 3 tiny bugfixes for 3.4-rc4.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (1):
      ARM: clps711x: serial driver hungs are a result of call disable_irq within ISR

Julia Lawall (1):
      drivers/tty/amiserial.c: add missing tty_unlock

Tomoya MORINAGA (1):
      pch_uart: Fix dma channel unallocated issue

 drivers/tty/amiserial.c       |    4 +++-
 drivers/tty/serial/clps711x.c |   14 ++++++++------
 drivers/tty/serial/pch_uart.c |    4 +++-
 3 files changed, 14 insertions(+), 8 deletions(-)
