Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0FHIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:54:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23031 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0FHIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:54:45 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 08 Jun 2010 11:47:52 +0300
Message-Id: <20100608084752.11914.19793.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.35-rc3
X-OriginalArrivalTime: 08 Jun 2010 08:53:48.0073 (UTC) FILETIME=[1BEA9990:01CB06E8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull few UBI changes which fix corrupted empty flash
handling:

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (4):
      UBI: simplify IO error codes
      UBI: introduce a new IO return code
      UBI: introduce eraseblock counter variables
      UBI: improve corrupted flash handling

 drivers/mtd/ubi/eba.c  |    7 ++-
 drivers/mtd/ubi/io.c   |   50 ++++++++++---------
 drivers/mtd/ubi/scan.c |  126 +++++++++++++++++++++++++++++++++++++-----------
 drivers/mtd/ubi/scan.h |   19 +++++--
 drivers/mtd/ubi/ubi.h  |   10 ++--
 5 files changed, 148 insertions(+), 64 deletions(-)

Thanks,
Artem.
