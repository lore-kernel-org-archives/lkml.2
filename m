Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1H0SrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:47:24 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:40710
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750971Ab1H0SrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:47:20 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0046] Staging: hv: Driver cleanup
Date: Sat, 27 Aug 2011 11:31:14 -0700
Message-Id: <1314469874-7017-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers. 

	1) Cleanup reference counting.

	2) Handle all block devices using the storvsc driver. I have modified
	   the implementation here based on Christoph's feedback on my earlier
	   implementation.

	3) Fix bugs.

	4) Accomodate some host side scsi emulation bugs.

	5) In case of scsi errors off-line the device.

This patch-set further reduces the size of Hyper-V drivers - the code is
about 10% smaller. This reduction is mainly because we have eliminated the
blkvsc driver.


Regards,

K. Y

