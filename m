Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114Ab1L0Fm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:42:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:14992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab1L0Fmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:42:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="91773371"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v2 0/3] ahci controller runtime PM support
Date: Tue, 27 Dec 2011 13:42:31 +0800
Message-Id: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the v2 patches to add ahci controller runtime PM support.
Applied on top of linux-next tree.

Thanks for any comments.

v2:
- add ahci hibernate callbacks

v1:
https://lkml.org/lkml/2011/12/15/198

Lin Ming (3):
      ahci: port legacy pm interface to struct dev_pm_ops
      ahci: add runtime PM callbacks
      ata: runtime suspend port if no device attached

 drivers/ata/ahci.c        |   71 +++++++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata-core.c |   21 ++++++++++++-
 2 files changed, 83 insertions(+), 9 deletions(-)

