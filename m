Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0HCJJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:09:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47895 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0HCJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:09:07 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Aug 2010 12:08:05 +0300
Message-Id: <20100803090805.13855.79802.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.36
X-OriginalArrivalTime: 03 Aug 2010 09:08:01.0309 (UTC) FILETIME=[5F9E14D0:01CB32EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please UBI changes.

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:

  Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (8):
      UBI: simplify IO error codes
      UBI: introduce a new IO return code
      UBI: introduce eraseblock counter variables
      UBI: improve corrupted flash handling
      UBI: improve ECC error message
      UBI: fix error message and compilation warnings
      UBI: do not print message about corruptes PEBs if we have none of them
      UBI: do not warn unnecessarily

Brijesh Singh (1):
      UBI: improve delete-compatible volumes handling

Matthieu CASTET (1):
      UBI: generate random image_seq when formatting MTD devices

 drivers/mtd/ubi/build.c |    3 +-
 drivers/mtd/ubi/eba.c   |   49 +++++++++++++++--
 drivers/mtd/ubi/io.c    |   60 ++++++++++++----------
 drivers/mtd/ubi/scan.c  |  131 ++++++++++++++++++++++++++++++++++++-----------
 drivers/mtd/ubi/scan.h  |   19 +++++--
 drivers/mtd/ubi/ubi.h   |   10 ++--
 6 files changed, 198 insertions(+), 74 deletions(-)

Thanks,
Artem.
