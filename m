Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2E3Bju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:39:50 -0400
Received: from masquerade.micron.com ([137.201.242.130]:51709 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2E3Bjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:39:48 -0400
Message-ID: <4FC57A61.5050607@micron.com>
Date: Tue, 29 May 2012 18:39:45 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 00/11] mtip32xx: Number of small tweaks and a new sysfs entry
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--9.229900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes number of small tweaks and adds a new sysfs entry 'flags'

Asai Thambi S P (11):
  mtip32xx: fix clearing an incorrect register in mtip_init_port
  mtip32xx: Set custom timeouts for PIO commands
  mtip32xx: Change HDIO_GET_IDENTITY to return stored data
  mtip32xx: Fix to handle TFE for PIO(IOCTL/internal) commands
  mtip32xx: Set block queue boundary variables
  mtip32xx: Use plain spinlock for 'cmd_issue_lock'
  mtip32xx: Fix to support more than one sector in exec_drive_command()
  mtip32xx: minor performance tweak
  mtip32xx: Convert macro definitions for flag bits to enum
  mtip32xx: Changes to sysfs entries
  mtip32xx: Change disk capacity unit from MB to MiB

 Documentation/ABI/testing/sysfs-block-rssd |   12 +-
 drivers/block/mtip32xx/mtip32xx.c          |  279 +++++++++++++++++-----------
 drivers/block/mtip32xx/mtip32xx.h          |   48 +++---
 3 files changed, 209 insertions(+), 130 deletions(-)

