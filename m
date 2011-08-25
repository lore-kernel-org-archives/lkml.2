Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1HYQ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:27:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46151
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752188Ab1HYQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:27:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0059] Staging: hv: Driver cleanup
Date: Thu, 25 Aug 2011 09:47:46 -0700
Message-Id: <1314290866-2644-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers. 

	1) Implement code for autoloading the vmbus drivers without using PCI or DMI
	   signatures. I have implemented this based on Greg's feedback on my earlier
	   implementation.

	2) Cleanup error handling across the board and use standard Linux error codes.

	3) General cleanup



Regards,

K. Y 

