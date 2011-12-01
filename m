Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1LAM6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:58:34 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:57096
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753527Ab1LAM6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:58:32 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0005] Staging: hv: storvsc cleanup
Date: Thu,  1 Dec 2011 04:58:35 -0800
Message-Id: <1322744315-13017-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc driver  based on review comments from James.

	1) While the existing per (virtual) HBA memory pools mechanism
	   does address the deadlock issues raised earlier since for IDE
	   devices there is a HBA per device and presently only IDE devices
	   can be drain devices, here we implement a generic per-LUN memory
	   pools mechanism.

	2) Fix a couple of bugs in the bounce buffer handling code (now that I
	   have been able to trigger these code paths!)

	3) Cleanup some unnecessary code.

With this, I believe I have addressed all of the review comments I have received
on this driver. I will submit a separate patch for moving the driver out of staging
(that includes these patches).


Regards,

K. Y

