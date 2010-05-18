Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0ERFgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:36:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:19669 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0ERFgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,252,1272870000"; 
   d="scan'208";a="568117351"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH -v3 0/2] x86, MCE, FIX MSR_IA32_MCI_CTL2_CMCI threshold setup
Date: Tue, 18 May 2010 13:36:29 +0800
Message-Id: <1274160991-21887-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:

v3:

- Separate patch into 2 patches, one for renaming, the other for threshold
  setup fixing.

v2:

- Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
  MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.
