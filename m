Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2LTWpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:45:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:15177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2LTWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,326,1355126400"; 
   d="scan'208";a="268018218"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH v2 0/2] gpio-langwell: update pci device table
Date: Thu, 20 Dec 2012 14:45:50 -0800
Message-Id: <1356043552-14579-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here goes 2nd try of Intel updates done on gpio-langwell driver.
Patch "gpio-langwell: update pci device table" is not include in this set
anymore due to it's already accepted and applied.

Kind regards,

David
---

David Cohen (1):
  gpio-langwell: cleanup driver

Li, Ning (1):
  gpio-langwell: implement irq shutdown interface

 drivers/gpio/gpio-langwell.c |   72 ++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

-- 
1.7.10.4

