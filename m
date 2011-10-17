Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1JQBUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:20:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38355 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1JQBUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:20:43 -0400
From: chris@cnpbagwell.com
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        pinglinux@gmail.com
Cc: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH 0/6] Add support for new (3rd generation) Bamboo P&T's.
Date: Sun, 16 Oct 2011 20:20:24 -0500
Message-Id: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bagwell <chris@cnpbagwell.com>

Wacom has released in the last month a 3rd generation of their
Bamboo Pen and Touch line and this patch series adds support
for them all. There are 3 new models.  2 include stylus and touch
support and can track up to 16 touches.  1 is a stylus only tablet.

A squashed version of this patch series has been tested by 1 user
for each tablet type over at linuxwacom-discuss mailing list.

Chris Bagwell (6):
  Input: wacom - cleanup feature report for bamboos
  Input: wacom - remove unused bamboo HID parsing
  Input: wacom - add some comments to wacom_parse_hid
  Input: wacom - relax Bamboo stylus ID check
  Input: wacom - read 3rd gen Bamboo Touch HID data
  Input: wacom - 3rd gen Bamboo P&Touch packet support

 drivers/input/tablet/wacom_sys.c |   94 ++++++++++++++++++++++++++++++++---
 drivers/input/tablet/wacom_wac.c |  101 ++++++++++++++++++++++++++++++++++----
 drivers/input/tablet/wacom_wac.h |    4 +-
 3 files changed, 179 insertions(+), 20 deletions(-)

-- 
1.7.6.4

