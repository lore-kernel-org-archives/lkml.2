Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2LSBwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:52:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:50674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab2LSBwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:52:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233626994"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 0/3] gpio-langwell updates
Date: Tue, 18 Dec 2012 17:52:10 -0800
Message-Id: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here goes some Intel updates done on gpio-langwell driver.

Kind regards,

David
---

David Cohen (2):
  gpio-langwell: cleanup driver
  gpio-langwell: update pci device table

Li, Ning (1):
  gpio-langwell: implement irq shutdown interface

 drivers/gpio/gpio-langwell.c |   80 ++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

-- 
1.7.10.4

