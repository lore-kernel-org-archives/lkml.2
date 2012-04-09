Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2DIC1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:27:47 -0400
Received: from masquerade.micron.com ([137.201.242.130]:1775 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2DIC1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:27:46 -0400
Message-ID: <4F824919.3090600@micron.com>
Date: Sun, 8 Apr 2012 19:27:37 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH v2 0/7] mtip32xx: Add support for device status and other
 changes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--3.480100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset adds support for new sysfs entry 'status' and other changes like
merging various flag variables, handling of commands. This also includes the 
new ABI file for this driver (Reported-by: Greg Kroah-Hartman).

I have split the couple of patches as suggested by Jens, and maintained the
order of the patches as in previous version. That is the reason for 'misc changes'
patch being in the middle.

Asai Thambi S P (7):
  mtip32xx: Add new bitwise flag 'dd_flag'
  mtip32xx: make setting comp_time as common
  mtip32xx: Add new sysfs entry 'status'
  mtip32xx: misc changes
  mtip32xx: Shorten macro names
  mtip32xx: handling of commands in various scenarios
  mtip32xx: dump tagmap on failure

 Documentation/ABI/testing/sysfs-block-rssd |   18 +
 drivers/block/mtip32xx/mtip32xx.c          |  830 ++++++++++++++++++++++------
 drivers/block/mtip32xx/mtip32xx.h          |   58 ++-
 3 files changed, 710 insertions(+), 196 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-rssd

