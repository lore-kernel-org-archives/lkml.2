Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1BVBWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:22:16 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:10143 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1BVBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:22:15 -0500
From: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
Subject: spi_topcliff_pch: reload issue
Date: Tue, 22 Feb 2011 10:22:11 +0900
Message-ID: <7FC6F7C4A6284C0FBD95D71D76B7528D@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvSLuuVguqATPrzRRqZBrgAILjPkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

issue: after reload the spi module, it can't do SPI communication.

We have faced issue when execute the following command.
insmod xxx.ko(Then, /dev/spidev0.0 is created with success)
rmmod xxx.ko (Then, /dev/spidev0.0 is deleted with success)
insmod xxx.ko(Then, /dev/spidev0.0 is created, however, below error message is showed)

  0000:02:0c.1: registered master spi0
  0000:02:0c.1: chipselect 0 already in use
  0000:02:0c.1: can't create new device for spidev

Do you have any information about the above ?

kernel=2.6.37 on FC14

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

