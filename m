Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1LMP5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:57:47 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57237
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753452Ab1LMP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:57:44 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: hv_storvsc driver
Date: Tue, 13 Dec 2011 07:58:36 -0800
Message-Id: <1323791916-2340-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sometime back I had sent the scsi mailing list, the patch to move the 
Hyper-V storage driver out of staging. This patch addresses  the
review comments I have gotten to date from James, Greg and Christoph (I have not heard
from anybody else in the  scsi mailing list). The patches addressing the review
comments have already been sent to the staging tree and Greg has already
applied these patches. James, Let me know what I can do to expedite the
move from the staging tree.

Greg, do you have any issues you would want
me to address before this driver can exit staging. Let me know.
 
Regards,

K. Y

