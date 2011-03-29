Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1C2VYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:24:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54302
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751975Ab1C2VYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:24:48 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 00/07] Remove and replace all un-needed DPRINT and printk
Date: Tue, 29 Mar 2011 13:58:43 -0700
Message-Id: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set removes all un-needed DPRINT and printk calls and replaces
the remaining ones with the correct pr_, dev_ and netdev_ calls 
from hv_vmbus, hv_netvsc, hv_timesource and hv_utils.

Several DPRINTS are remaining that will be cleaned up in my next
set of patches. They deal with printing out certain debugging that will be 
implemented slightly differently.

The remaining hv_storvsc and hv_blkvsc will get the same treatment in
a different set of patches.

Regards,

Hank Janssen <hjanssen@microsoft.com>

