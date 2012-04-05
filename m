Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2DEU7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:59:52 -0400
Received: from masquerade.micron.com ([137.201.242.130]:61453 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2DEU7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:59:51 -0400
Message-ID: <4F7E07BB.4080507@micron.com>
Date: Thu, 5 Apr 2012 13:59:39 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 0/5] mtip32xx: Add support for device status and some optimitizations
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No-6.811100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset adds support for new sysfs entry 'status', fix in restart port,
and some optimizations like merging various flag variables. 

Asai Thambi S P (5):
  mtip32xx: Add new bitwise flag 'dd_flag' and make set comp_time as
    common
  mtip32xx: Add new sysfs entry 'status' and fix restart port
  mtip32xx: Shorten macro names
  mtip32xx: handling of commands in various scenarios
  mtip32xx: dump tagmap on failure

 drivers/block/mtip32xx/mtip32xx.c |  844 +++++++++++++++++++++++++++++--------
 drivers/block/mtip32xx/mtip32xx.h |   58 ++-
 2 files changed, 702 insertions(+), 200 deletions(-)

