Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2IEQaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:30:25 -0400
Received: from masquerade.micron.com ([137.201.242.130]:16559 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2IEQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:30:24 -0400
Message-ID: <50477E0E.2070002@micron.com>
Date: Wed, 5 Sep 2012 22:00:06 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 0/6] mtip32xx: Support for new devices and minor changes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No-9.472200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for new devices and few minor changes.

Asai Thambi S P (6):
  mtip32xx: Add support for new devices
  mtip32xx: Handle NCQ commands during the security locked state
  mtip32xx: Increase timeout for standby command
  mtip32xx: Proper reporting of write protect status on big-endian
  mtip32xx: Change printk to pr_xxxx
  mtip32xx: Remove dead code

 drivers/block/mtip32xx/mtip32xx.c |   36 ++++++++++++++++++++++--------------
 drivers/block/mtip32xx/mtip32xx.h |   10 +++++++++-
 2 files changed, 31 insertions(+), 15 deletions(-)

