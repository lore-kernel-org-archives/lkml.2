Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2FLKm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:42:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39127 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2FLKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:42:26 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/3] Minor g_mass_storage improvements.
Date: Tue, 12 Jun 2012 12:42:15 +0200
Message-Id: <cover.1339497368.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Second version with comments from Alan included in the third patch.
This is based on top of Linux 3.5-rc2 (aka Greg's usb-next).

IIRC Felipe has already pulled the first patch in the series, but
I couldn't find a proper branch on Felipe's tree to base my patchset
on that would include it, so resending.

It would be nice if at least the first and the last patch from the
series were pulled together to the same Linux version.

Michal Nazarewicz (3):
  usb: gadget: mass_storage: change default value of the removable
    parameter
  usb: gadget: mass_storage: remove unused options
  usb: gadget: mass_storage: add documentation

 Documentation/usb/mass-storage.txt  |  226 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_mass_storage.c |  109 ++---------------
 2 files changed, 237 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/usb/mass-storage.txt

-- 
1.7.7.3

