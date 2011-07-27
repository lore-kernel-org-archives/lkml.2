Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1G0EFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50547 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab1G0EFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:32 -0400
X-Sasl-enc: 2GcLCyouVI+sd3aMFj6gsKsMgUG4xNZFQCPNtMsH7+J3 1311739530
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/11] DOCUMENTATION: Replace create_device() with device_create().
Date: Tue, 26 Jul 2011 21:05:13 -0700
Message-Id: <1311739521-11014-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Fix a rather obvious typo.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/device.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index b2ff426..bdefe72 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -104,4 +104,4 @@ Then in the module init function is would do:
 
 And assuming 'dev' is the struct device passed into the probe hook, the driver
 probe function would do something like:
-	create_device(&mydriver_class, dev, chrdev, &private_data, "my_name");
+	device_create(&mydriver_class, dev, chrdev, &private_data, "my_name");
-- 
1.7.6

