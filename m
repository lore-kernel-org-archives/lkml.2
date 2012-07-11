Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2GKN4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:56:34 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57094 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2GKN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:56:32 -0400
Date: Wed, 11 Jul 2012 06:56:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] misc fixes patches for 3.5-rc6
Message-ID: <20120711135628.GA19561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.5-rc6

for you to fetch changes up to 16a50b1270455a6d41f9f6d8f99a72cf9d76824a:

  mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq (2012-07-10 10:45:07 -0700)

----------------------------------------------------------------
MISC fix for 3.5-rc6

Here's a single MEI driver fix that resolves a regression from 3.4 that a
number of people have reported (and sent to me in different patches.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Tomas Winkler (1):
      mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq

 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
