Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1IHOCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:02:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33123
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932902Ab1IHOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:02:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0025] Staging: hv: Driver cleanup
Date: Thu,  8 Sep 2011 07:24:03 -0700
Message-Id: <1315491843-9513-1-git-send-email-kys@microsoft.com>
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

	4) Other general cleanup.


Regards,

K. Y

