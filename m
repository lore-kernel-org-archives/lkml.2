Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1JDQPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:15:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64857 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1JDQPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:15:02 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Oct 2011 10:14:41 -0600
X-Google-Sender-Auth: -7Gcus19aJ8OwVQvmEgLluOXDig
Message-ID: <CACxGe6uPnXm4Ehk0Bwss_B48j3oUtE1L8SSTyCE6nC2b9K0hhA@mail.gmail.com>
Subject: [GIT PULL] spi driver bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some bug fixes for the topcliff spi driver.

Tomoya, are these applicable for the stable tree?

The following changes since commit 0f86267b79bc6e357b8606077c7f70239045ea9c:

  Merge branch 'hwmon-for-linus' of git://github.com/groeck/linux
(2011-10-03 12:54:56 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/merge

Tomoya MORINAGA (5):
      spi-topcliff-pch: add tx-memory clear after complete transmitting
      spi-topcliff-pch: Fix SSN Control issue
      spi-topcliff-pch: Fix CPU read complete condition issue
      spi-topcliff-pch: Add recovery processing in case FIFO overrun
error occurs
      spi-topcliff-pch: Fix overrun issue

 drivers/spi/spi-topcliff-pch.c |   93 ++++++++++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 27 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
