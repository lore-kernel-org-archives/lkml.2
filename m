Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1H3FQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:16:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:14224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1H3FQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:16:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,300,1312182000"; 
   d="scan'208";a="43768235"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: [PATCH -mm 0/2] Use llist in irq_work and xlist
Date: Tue, 30 Aug 2011 13:16:22 +0800
Message-Id: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove the code duplication.

[PATCH -mm 1/2] irq_work, Use llist in irq_work
[PATCH -mm 2/2] net, rds, Replace xlist in net/rds/xlist.h with llist

Best Regards,
Huang Ying
