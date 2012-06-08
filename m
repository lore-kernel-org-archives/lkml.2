Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2FHIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:01:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:62602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab2FHIBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:01:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149938417"
From: Xudong Hao <xudong.hao@intel.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        ddutile@redhat.com, myron.stowe@redhat.com, xiantao.zhang@intel.com,
        xudong.hao@intel.com
Subject: [PATCH 0/4] PCI: Enable LTR/OBFF before device is used by driver
Date: Fri,  8 Jun 2012 16:01:28 +0800
Message-Id: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches enable LTR and OBFF before device is used by driver, and
introduce a couple of functions to save/restore LTR latency value.

Patch 1/4 introduce new function pci_obff_supported() as pci_ltr_support().

Patch 2/4 enable LTR(Latency tolerance reporting) before device is used by
driver.

Patch 3/4 enable OBFF(optimized buffer flush/fill) before device is used by
driver.

Patch 4/4 introduce a couple of functions pci_save_ltr_value() and
pci_restore_ltr_value() to save and restore LTR latency value, while device is
reset.
