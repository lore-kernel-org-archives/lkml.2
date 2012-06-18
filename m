Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2FRMhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:37:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44114 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRMhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:37:36 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] A few mass_storage fixes.
Date: Mon, 18 Jun 2012 14:37:18 +0200
Message-Id: <cover.1340022674.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Two fixes to the "file" sysfs entry handling and one patch removing
unused code.

Michal Nazarewicz (3):
  usb: gadget: storage_common: remove FSG_BUFFHD_STATIC_BUFFER support
  usb: gadget: mass_storage: fail fsg_store_file() early if colud not
    open file
  usb: gadget: mass_storage: require backing file for non-removable
    LUNs

 drivers/usb/gadget/storage_common.c |   65 +++++++++++++++++------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

-- 
1.7.7.3

