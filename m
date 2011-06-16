Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1FPUBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:01:17 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50845
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756102Ab1FPUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/77] Staging: hv: Driver cleanup
Date: Thu, 16 Jun 2011 13:16:33 -0700
Message-Id: <1308255393-3785-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers:

	1) On some loaded hosts, we have discovered that the host does not respond to
	   the guest within the specified interval - currently one second. Increase the
	   timeout value in the guest.

	2) Implement code for autoloading the vmbus drivers without using PCI or DMI
	   signatures.

	3) Cleanup error handling across the board and use standard Linux error codes.

	4) General cleanup

	5) Some bug fixes.
	  

Regads,

K. Y 


