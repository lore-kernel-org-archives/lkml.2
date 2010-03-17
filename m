Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0CQPYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:24:22 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:45161 "EHLO castor.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294Ab0CQPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:24:21 -0400
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, jmm@debian.org,
       mithlesh@linsyssoft.com
Subject: [PATCH 0/3] staging wlan-ng: refactor p80211wext.c & 1 minor fix
Date: Wed, 17 Mar 2010 14:30:20 +0000
Message-Id: <1268836223-31620-1-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 patches to tidy up the wlan-ng wext interface, reducing text size & LOC.

They've been tested on my x86_32 laptop and it all seems to work correctly.

All patches against 2.6.34-rc1.

  staging wlan-ng: p80211wext.c tidy up iw_handler
  staging wlan-ng: p80211wext.c fix p80211wext_mhz_to_channel for channel 14
  staging wlan-ng: refactor p80211wext.c to reduce text size.

 drivers/staging/wlan-ng/p80211wext.c |  398 ++++++++++++++--------------------
 1 files changed, 159 insertions(+), 239 deletions(-)

