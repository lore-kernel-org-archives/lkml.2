Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0KAFe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 01:34:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41378 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0KAFeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 01:34:25 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 1 Nov 2010 01:34:03 -0400
X-Google-Sender-Auth: WR4pkmQwtIgx65jQmfQY5s_Pjp8
Message-ID: <AANLkTi=2mw0YN+6fWAkuXwmeeeOgj8XikN3aTsRa4xaU@mail.gmail.com>
Subject: [git pull] spi bug fixes for 2.6.37
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Some spi bug fixes in this branch.

g.

The following changes since commit 3985c7ce85039adacdf882904ca096f091d39346:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
(2010-10-30 18:42:58 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Feng Tang (1):
      spi: enable spi_board_info to be registered after spi_master

Linus Walleij (2):
      spi: fixed odd static string conventions in core code
      spi/pl022: fix erroneous platform data in U300

Michael Hennerich (2):
      spi/bfin_spi: handle error/status changes after data interrupts
      spi/bfin_spi: only request GPIO on first load

 arch/arm/mach-u300/spi.c  |    2 +-
 drivers/spi/spi.c         |   98 ++++++++++++++++++++++++---------------------
 drivers/spi/spi_bfin5xx.c |   22 ++++++++--
 include/linux/spi/spi.h   |    3 +
 4 files changed, 73 insertions(+), 52 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
