Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2DXJ1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:27:20 -0400
Received: from smtp.nokia.com ([147.243.128.26]:26204 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab2DXJ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:27:19 -0400
Message-ID: <1335259628.11311.0.camel@groo>
Subject: [GIT PULL] HSI fixes for 3.4
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        gregkh@linuxfoundation.org
Date: Tue, 24 Apr 2012 12:27:08 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following HSI fixes needed for 3.4

Greg KH found some issues that need to be addressed prior 3.4 release:

https://lkml.org/lkml/2012/4/2/511
https://lkml.org/lkml/2012/4/2/512

Here you have the link to the discussion of the patches and the Acked-by granted from Greg KH and Linus Walleij:

https://lkml.org/lkml/2012/4/19/144

The signed tag covering those patches: hsi_fixes_for_3.4

Thanks & Br,
Carlos Chinea

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:
  git://gitorious.org/kernel-hsi/kernel-hsi.git for-linus

Carlos Chinea (6):
      HSI: hsi: Rework hsi_controller release
      HSI: hsi: Fix error path cleanup on client registration
      HSI: hsi: Remove controllers and ports from the bus
      HSI: hsi: Rework hsi_event interface
      HSI: hsi_char: Remove max_data_size from sysfs
      HSI: Add HSI ABI documentation

 Documentation/ABI/testing/sysfs-bus-hsi |   19 +++
 drivers/hsi/clients/hsi_char.c          |    2 +-
 drivers/hsi/hsi.c                       |  223 ++++++++++++++++---------------
 include/linux/hsi/hsi.h                 |   31 +++--
 4 files changed, 155 insertions(+), 120 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-hsi



