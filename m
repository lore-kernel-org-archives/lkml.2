Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1DSNbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:31:35 -0400
Received: from smtp.nokia.com ([147.243.128.26]:62409 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1DSNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:31:33 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] usb: gadget: Make mass_storage pass USBCV MSC Compliance tests
Date: Tue, 19 Apr 2011 16:33:51 +0300
Message-Id: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch makes composite framework support a mechanism of defering
setup transfer's data/status phase.

Second patch makes f_mass_storage use that mechanism.

Together they help the composite devices using f_mass_storage interface to
pass USBCV Mass Storage Class compliance tests.

---
Roger Quadros (2):
  usb: gadget: composite: Allow function drivers to defer setup
    responses
  usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests

 drivers/usb/gadget/composite.c      |   61 ++++++++++++++++++++++++++++++++++-
 drivers/usb/gadget/f_mass_storage.c |    6 +++-
 include/linux/usb/composite.h       |   17 +++++++++-
 3 files changed, 81 insertions(+), 3 deletions(-)

