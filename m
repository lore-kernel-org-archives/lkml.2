Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1HOXLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:11:08 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46172
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751560Ab1HOXLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:11:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/8] Staging: hv: vmbus: Driver cleanup
Date: Mon, 15 Aug 2011 15:10:10 -0700
Message-Id: <1313446210-10611-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the vmbus driver:

	1) Cleanup the interrupt handler by inlining some code. 

	2) Ensure message handling is performed on the same CPU that
	   takes the vmbus interrupt. 

	3) Check for events before messages (from the host).

	4) Disable auto eoi for the vmbus interrupt since Linux will eoi the
	   interrupt anyway. 

	5) Some general cleanup.
	  

Regards,

K. Y 


