Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1DEPeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:34:25 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47537 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab1DEPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:14 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] fixes for f_mass_storage
Date: Tue,  5 Apr 2011 18:36:37 +0300
Message-Id: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches contain some fixes and improvements for f_mass_storage.c

cheers,
-roger

---
Roger Quadros (5):
  usb: gadget: f_mass_storage: Fix Bulk-only RESET handling
  usb: gadget: f_mass_storage: If 'ro'/'cdrom' specified, open file as
    read-only
  usb: gadget: f_mass_storage: Prevent NULL pointer dereference
  usb: gadget: f_mass_storage: Fix potential memory leak
  usb: gadget: f_mass_storage: remove unnecessary initialization

 drivers/usb/gadget/f_mass_storage.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

