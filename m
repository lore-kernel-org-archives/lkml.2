Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1CKU7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:59:13 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32471 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1CKU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:59:08 -0500
Subject: [PATCH 0/7] cciss: updates as of March 11, 2011
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 11 Mar 2011 14:55:29 -0600
Message-ID: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is vs. Jens Axboe's for-2.6.39/drivers branch. 

---

Stephen M. Cameron (7):
      cciss: hoist tag masking out of loop
      cciss: Inform controller we are using 32-bit tags.
      cciss: Mask off error bits of c->busaddr in cmd_special_free when calling pci_free_consistent
      cciss: remove unnecessary casts
      cciss: fix missed command status value CMD_UNABORTABLE
      cciss: add cciss_tape_cmds module paramter
      cciss: export resettable host attribute


 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   11 ++
 Documentation/blockdev/cciss.txt                   |   15 +++
 drivers/block/cciss.c                              |   97 ++++++++++++++++----
 drivers/block/cciss_cmd.h                          |    1 
 drivers/block/cciss_scsi.c                         |   54 +++++++----
 drivers/block/cciss_scsi.h                         |    4 -
 6 files changed, 140 insertions(+), 42 deletions(-)

-- 
-- steve
