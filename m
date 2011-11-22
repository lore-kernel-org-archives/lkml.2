Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1KVA7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:59:35 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36784 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab1KVA7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:34 -0500
X-Sasl-enc: 3grxTCnaA8pNq/X3c+c+MB6PuVYq5h9EZGrGx4TXA2s7 1321923573
Date: Mon, 21 Nov 2011 16:58:36 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char and misc fixes for 3.2
Message-ID: <20111122005836.GA25420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd and I are going to be trying to tame the char and misc drivers, so
here's a pull request to add us as maintainers, and a few other minor
misc driver fixes that are needed for the 3.2 release.

Please pull from:
	git.kernel.org:/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-linus

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 MAINTAINERS                          |    8 +++
 drivers/misc/Kconfig                 |   15 +++---
 drivers/misc/ad525x_dpot.h           |    2 +-
 drivers/misc/pch_phub.c              |   81 ++++++++++++++++++++++++---------
 drivers/misc/spear13xx_pcie_gadget.c |    2 +-
 5 files changed, 77 insertions(+), 31 deletions(-)

---------------

Axel Lin (1):
      pcie-gadget-spear: Add "platform:" prefix for platform modalias

Greg Kroah-Hartman (1):
      MAINTAINERS: add CHAR and MISC driver maintainers

Michael Hennerich (1):
      misc: ad525x_dpot: Fix AD8400 spi transfer size.

Tomoya MORINAGA (4):
      pch_phub: Support new device LAPIS Semiconductor ML7831 IOH
      pch_phub: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      pch_phub: Improve ADE(Address Decode Enable) control
      pch_phub: Fix MAC address writing issue for LAPIS ML7831

