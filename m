Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2JBV0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:26:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:26015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab2JBV0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="229741416"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [PATCH 0/2] PCI-Express Non-Transparent Bridge Support 
Date: Tue,  2 Oct 2012 14:26:15 -0700
Message-Id: <1349213177-9985-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am submitting version 4 of the PCI-Express Non-Transparent Bridge
patches for inclusion in 3.7.  All outstanding issues from the RFC
process have been addressed.

version 1
http://thread.gmane.org/gmane.linux.kernel.pci/16443

Version 2 incorporates numerous clean-ups 
http://thread.gmane.org/gmane.linux.kernel.pci/16696

Version 3 incorporates changes to conform NTB and client devices to the
Linux device model (per Greg KH's request).
http://thread.gmane.org/gmane.linux.kernel.pci/17808

Version 4 removes the transport transmit tasklet (per Dave Miller's
request).
http://thread.gmane.org/gmane.linux.network/244491

Thanks,
Jon

