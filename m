Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1IMRhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:37:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:50661
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755728Ab1IMRhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:37:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0020] Staging: hv: Driver cleanup
Date: Tue, 13 Sep 2011 10:59:19 -0700
Message-Id: <1315936759-20623-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address Greg's VmBus audit comments:

	1) Leverage driver_data field in struct hv_vmbus_device_id to
	   simplify driver code.

	2) Make the util driver conform to the Linux Driver Model.

	3) Get rid of the ext field in struct hv_device by using the
	   driver specific data functionality.

	4) Implement vmbus specific wrapper functions for setting and getting
	   driver specific data..

	5) Other general cleanup.


Regards,

K. Y

