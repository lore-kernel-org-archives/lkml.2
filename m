Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1ICF3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:29:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:22272 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1ICF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,323,1312182000"; 
   d="scan'208";a="13708582"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, mjg59@srcf.ucam.org
Cc: linux-kernel@vger.kernel.org
Subject: pstore: enhancement for pstore write interface
Date: Sat,  3 Sep 2011 13:30:15 +0800
Message-Id: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] pstore: change the purpose of return value for pstore
[PATCH 2/2] pstore: update the policy of the UEFI-based backend

These two patches are for pstore write interface enhancement.
The 1st one updates the original write interface to return a valid
write result. The 2nd one updates the UEFI-based pstore backend
write policy. For the 2nd one, though Matthew current design is to
reduce UEFI variable space usage, but I think it is still too strict
as a log storage. :-)
