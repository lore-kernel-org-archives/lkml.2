Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0JaUTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 16:19:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14960 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0JaUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 16:19:11 -0400
Date: Sun, 31 Oct 2010 21:19:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [GIT PULL] Late i2c updates for 2.6.37
Message-ID: <20101031211904.7c0ab7c5@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull late i2c subsystem updates for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

These depended on changes in other trees, which I had to wait for you
to merge before I could send them.

 Documentation/i2c/busses/i2c-i801   |    6 +-
 drivers/i2c/busses/Kconfig          |    1 +
 drivers/i2c/busses/i2c-i801.c       |  333 ++++++++++++++++++++---------------
 drivers/staging/tm6000/tm6000-i2c.c |    1 -
 include/linux/i2c.h                 |    2 -
 include/linux/pci_ids.h             |    1 +
 6 files changed, 196 insertions(+), 148 deletions(-)

---------------

David Woodhouse (2):
      i2c-i801: Handle multiple instances instead of keeping global state
      i2c-i801: Add PCI idents for Patsburg 'IDF' SMBus controllers

Jean Delvare (1):
      i2c: Drop unused I2C_CLASS_TV flags

Seth Heasley (1):
      i2c-i801: Add Intel Patsburg device ID

Thanks,
-- 
Jean Delvare
