Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2ALUel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:34:41 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34269
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755175Ab2ALUek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:34:40 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0015] Staging: hv: storvsc cleanup
Date: Thu, 12 Jan 2012 12:37:17 -0800
Message-Id: <1326400637-13494-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc driver  based on the latest review comments from Christoph:

	1. Get rid of unnecessary comments and unused defines. Use a consistent
	   style for comments.

	2. Cleanup all the structure definitions used in communication with
	   the host. Also consolidate all protocol related definitions to
	   a single location in the file.

	3. Get rid of some unnecessary indirection and consolidate the state in
	   request structure.

	4. Some general cleanup.

With this, I believe I have addressed all of the review comments I have received
on this driver. I will submit a separate patch for moving the driver out of staging
(that includes these patches).


Regards,

K. Y

