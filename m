Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1CKSnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:43:07 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:36613 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab1CKSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:43:04 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/2] hid-input: Keyboard and MT support for MacBookPro8
Date: Fri, 11 Mar 2011 19:45:21 +0100
Message-Id: <1299869123-18346-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.4.1
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Py7IL-0001JB-4c.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Py7IL-0001JB-4c 6157993e5a08b5d059de1dd39e1784fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Dmitry,

Keyboard and MT support for the new MacBookPro models. The first patch
is against HID, the second against Input. As usual, they need to be
synced.

The patches have been tested on the Ubuntu forums, many thanks to Andy
for the nice patches.

Thanks,
Henrik

Andy Botting (2):
  HID: hid-apple: Add keyboard support for MacBookPro8
  Input: bcm5974 - add support for MacBookPro8

 drivers/hid/hid-apple.c       |    6 ++++++
 drivers/hid/hid-core.c        |    6 ++++++
 drivers/hid/hid-ids.h         |    3 +++
 drivers/input/mouse/bcm5974.c |   20 ++++++++++++++++++++
 4 files changed, 35 insertions(+), 0 deletions(-)

-- 
1.7.4.1

