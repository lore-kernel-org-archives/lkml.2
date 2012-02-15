Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2BOKTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:19:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:2540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2BOKTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="107904429"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RESEND PATCH v2 0/3] ahci controller runtime PM support
Date: Wed, 15 Feb 2012 18:18:49 +0800
Message-Id: <1329301132-3687-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

(RESEND, now applied on top of libata/ALL branch)

Here is the v2 patches to add ahci controller runtime PM support.

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

