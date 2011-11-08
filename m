Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1KHQfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:35:54 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54388
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751506Ab1KHQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:35:54 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0011] Staging: hv: storvsc cleanup/new features
Date: Tue,  8 Nov 2011 09:01:17 -0800
Message-Id: <1320771677-29095-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc based on review comments from James and
implement a couple of new features:

	1) The bulk of this patch-set addresses the review comments by James.
	   James, the last time I had posted the patch to move the storage
	   driver out of staging, you wanted to wait until Greg's tree had
	   percolated up. Now, Greg's staging/hv has been merged up. Do you 
	   now want me to re-post the patch to move the storage driver 
	   out of staging? Let me know.

	2) I have also implemented the feature to support hot add/remove
	   of devices configured under the scsi controller on the host.

Regards,

K. Y

