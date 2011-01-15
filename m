Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1AOA7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:59:21 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:4696 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428Ab1AOA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:59:19 -0500
Subject: [PATCH net-next 0/8] vmxnet3 fixes and enhancements
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Shreyas N Bhatewara <sbhatewara@vmware.com>
Cc: pv-drivers@vmware.com
Date: Fri, 14 Jan 2011 16:59:20 -0800
Message-ID: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes bugs and enhances functionality in the
vmxnet3 driver.

---

Shreyas N Bhatewara (8):
      vmxnet3: fix ring size update
      vmxnet3: Preserve the MAC address configured by ifconfig
      vmxnet3: Enable HW Rx VLAN stripping by default
      vmxnet3: Provide required number of bytes in first SG buffer
      vmxnet3: Make ethtool handlers multiqueue aware
      vmxnet3: Disable napi in suspend, reenable in resume.
      vmxnet3: Add locking for access to command register
      vmxnet3: Dont allocate extra MSI-x vectors


 drivers/net/vmxnet3/vmxnet3_drv.c     |   93 +++++++----
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  274 +++++++++++++++++++--------------
 drivers/net/vmxnet3/vmxnet3_int.h     |    7 -
 3 files changed, 226 insertions(+), 148 deletions(-)

-- 
Thanking you.
Shreyas
