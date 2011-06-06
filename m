Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1FFWeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:34:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57439
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751921Ab1FFWeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/49] Staging: hv: Driver cleanup
Date: Mon,  6 Jun 2011 15:49:00 -0700
Message-Id: <1307400540-13193-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers:

	1) Continue to cleanup our drivers to conform to the Linux Driver
	   Model.

	2) Fix some long standing bugs with regards to unloading and 
	   reloading the drivers - block, net and stor.

	3) VMBUS is an ACPI enumerated device; make VMBUS an ACPI bus driver.

	4) Get rid of channel polling code; instead the channel receive paths 
	   will be purely interrupt drive.

	5) Cleanup error return values in the vmbus driver and general cleanup.

	6) Fix memory barrier calls in the ring buffer code.

	7) Increase the timeout values for some critical guest to host calls.


Regads,

K. Y 


