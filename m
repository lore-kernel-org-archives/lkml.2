Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GAB3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:29:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1GAB3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:29:14 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] char drivers: ramoops improvements
Date: Thu, 30 Jun 2011 18:28:37 -0700
Message-Id: <1309483720-1407-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improves the ramoops module by adding a dump_oops to the platform data, 
adding a record_size parameter and adding a debugfs for memory area access.

The patch was built on the 2.6.38 kernel and is based on the following
patches which were applied from the mmotm tree:
ramoops-add-new-line-to-each-print
ramoops-use-module-parameters-instead-of-platform-data-if-not-available
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes

This series is different from the initial by being built on the ramoops 
modifications present in the mmotm tree and by adding the debugfs patch along
with minor improvements.

The changes were tested on a CR-48 machine using the 2.6.38 kernel.

Sergiu Iordache (3):
  char drivers: ramoops dump_oops platform data
  char drivers: ramoops record_size module parameter
  char drivers: ramoops debugfs entry

 drivers/char/ramoops.c  |  139 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/ramoops.h |    2 +
 2 files changed, 133 insertions(+), 8 deletions(-)

-- 
1.7.3.1

