Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab1JEEo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:44:28 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:20387 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724Ab1JEEo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:44:26 -0400
From: "Tomoya MORINAGA" <Tomoya.Morinaga@dsn.rohm.co.jp>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        "'Tomoya MORINAGA'" <morinaga526@dsn.okisemi.com>, <stable@kernel.org>
References: <CACxGe6uPnXm4Ehk0Bwss_B48j3oUtE1L8SSTyCE6nC2b9K0hhA@mail.gmail.com>
Subject: RE: [GIT PULL] spi driver bug fixes
Date: Wed, 5 Oct 2011 13:44:21 +0900
Message-ID: <95F40BC8A9814963B7347EF0C1B3B50B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcyCsMZR2LDv2e8USFSSRa+Z117XVgAaDwVw
In-Reply-To: <CACxGe6uPnXm4Ehk0Bwss_B48j3oUtE1L8SSTyCE6nC2b9K0hhA@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 05, 2011 1:15 AM, Grant Likely wrote:
> Tomoya, are these applicable for the stable tree?
Yes, these are applicable for the stable.

------
Tomoya
ROHM Co., Ltd.

-----Original Message-----
From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
Sent: Wednesday, October 05, 2011 1:15 AM
To: Linus Torvalds; Linux Kernel Mailing List; spi-devel-general@lists.sourceforge.net; Tomoya
MORINAGA; stable@kernel.org
Subject: [GIT PULL] spi driver bug fixes

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
      spi-topcliff-pch: Add recovery processing in case FIFO overrun error occurs
      spi-topcliff-pch: Fix overrun issue

 drivers/spi/spi-topcliff-pch.c |   93 ++++++++++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 27 deletions(-)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

