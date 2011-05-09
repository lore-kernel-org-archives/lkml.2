Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1EIKFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:05:35 -0400
Received: from smtp.nokia.com ([147.243.128.24]:65491 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1EIKFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:05:33 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] usb: gadget: Make mass_storage pass USBCV MSC Compliance tests
Date: Mon,  9 May 2011 13:08:05 +0300
Message-Id: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
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

Changes in v2:
- Review comments addressed
- Regression fix - USBCV CH-9 fails on 2nd run on composite gadget with storage

---
Roger Quadros (2):
  usb: gadget: composite: Allow function drivers to pause control
    transfers
  usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests

 drivers/usb/gadget/composite.c      |   62 ++++++++++++++++++++++++++++++++++-
 drivers/usb/gadget/f_mass_storage.c |    6 +++-
 include/linux/usb/composite.h       |   16 ++++++++-
 3 files changed, 81 insertions(+), 3 deletions(-)

