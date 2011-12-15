Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab1LONOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:14:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:11990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1LONOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:14:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87652557"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC][PATCH 0/4] ahci controller runtime PM support
Date: Thu, 15 Dec 2011 21:12:45 +0800
Message-Id: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The ata port runtime PM support patches have been merged.
Now I move on to ahci controller runtime PM support.

My test enviroment is:
1. use nfsroot, so disk is not mounted. AHCI controller can be runtime suspended.
2. use eSATA to test if hot plug works with port/controller runtime suspended.

I send these RFC patches to get feedbacks.
Any comment is much appriciated.

[RFC][PATCH 1/4] ahci: port legacy pm interface to struct dev_pm_ops
[RFC][PATCH 2/4] ahci: add runtime PM callbacks
[RFC][PATCH 3/4] ata: runtime suspend port if no device attached
[RFC][PATCH 4/4] ahci: support hot plug when port/controller is runtime suspended

Thanks,
Lin Ming
