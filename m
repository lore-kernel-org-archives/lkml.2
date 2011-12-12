Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1LLSCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:02:52 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56582
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752129Ab1LLSCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:02:45 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0004] Drivers: hv: Fixes 
Date: Mon, 12 Dec 2011 09:28:51 -0800
Message-Id: <1323710931-29616-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixes to the vmbus driver:

	1. Fix a memory leak in a failure path.

	2. Make vmbus driver unloadable.

	3. Get rid of an unnecessary check in hv_init()
	   in preparation for supporting kexec().

	4. Make it possible to build the vmbus driver as part of the
	   kernel. This patch was submitted earlier, but seems to have been 
	   lost.

Regards,

K. Y

