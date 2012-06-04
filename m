Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2FDTmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:42:40 -0400
Received: from masquerade.micron.com ([137.201.242.130]:60656 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2FDTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:42:38 -0400
Message-ID: <4FCD0FA9.2040209@micron.com>
Date: Mon, 4 Jun 2012 12:42:33 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 0/2] Move sysfs entries to debugfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18948.001
X-TM-AS-Result: No--0.888900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset move 'registers' and 'flags' entries from sysfs to debugfs.

Asai Thambi S P (2):
  mtip32xx: Remove 'registers' and 'flags' from sysfs
  mtip32xx: Create debugfs entries for troubleshooting

 Documentation/ABI/testing/sysfs-block-rssd |   21 ----
 drivers/block/mtip32xx/mtip32xx.c          |  166 ++++++++++++++++++++--------
 drivers/block/mtip32xx/mtip32xx.h          |    4 +
 3 files changed, 122 insertions(+), 69 deletions(-)

