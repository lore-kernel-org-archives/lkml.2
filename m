Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2LEODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:03:10 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51151 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LEODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:03:08 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] i2c-hid cleanup and bug fixes
Date: Wed,  5 Dec 2012 15:02:52 +0100
Message-Id: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Jean,

This is the v2 of the cleanup of i2c-hid.

Changes since v1:
* patch 1: check if dsize < 4
* patch 2: no changes
* patch 3: fixed irq return path
* patch 4: correct *_count handling (much more tested this time).

Cheers,
Benjamin

Benjamin Tissoires (4):
  HID: i2c-hid: fix memory corruption due to missing hid declaration
  HID: i2c-hid: reorder allocation/free of buffers
  HID: i2c-hid: remove extra .irq field in struct i2c_hid
  HID: i2c-hid: fix i2c_hid_get_raw_report count mismatches

 drivers/hid/i2c-hid/i2c-hid.c | 108 +++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 55 deletions(-)

-- 
1.8.0.1

