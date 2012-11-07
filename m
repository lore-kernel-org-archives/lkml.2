Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2KGM20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:28:26 -0500
Received: from masquerade.micron.com ([137.201.242.130]:28104 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2KGM2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:28:25 -0500
Message-ID: <509A5ABF.80804@micron.com>
Date: Wed, 7 Nov 2012 05:57:35 -0700
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <sbradshaw@micron.com>, <asamymuthupa@micron.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] mtip32xx: Few small fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19346.007
X-TM-AS-Result: No--2.162200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Few more minor fixes for 3.7.

This patchset contains fix for the lba address problem in big-endian, potential 
crash on secure erase operation and incorrect erase mode mask

Asai Thambi S P (3):
  mtip32xx: fix potential crash on SEC_ERASE_UNIT
  mtip32xx: Fix to make lba address correct in big-endian systems
  mtip32xx: Fix incorrect mask used for erase mode

 drivers/block/mtip32xx/mtip32xx.c |   12 ++++++++----
 drivers/block/mtip32xx/mtip32xx.h |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

