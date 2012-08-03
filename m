Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab2HCE3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:29:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HCE3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:29:42 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        mjg@redhat.com, ibm-acpi@hmh.eng.br
Subject: [PATCH] thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR
Date: Thu,  2 Aug 2012 23:29:36 -0500
Message-Id: <1343968176-20898-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

In the latest V-series bios DMI_PRODUCT_VERSION does not contain
the string Lenovo or Thinkpad, but is set to the model number, this
causes the thinkpad_acpi module to fail to load. Recognize laptop
as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.

BIOS Information
        Vendor: LENOVO
        Version: H7ET21WW (1.00 )

System Information
        Manufacturer: LENOVO
        Product Name: LV5DXXX
        Version: V490u

This was tested by me on the Lenovo V490u

Manoj Iyer (1):
  thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

 drivers/platform/x86/thinkpad_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5

