Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2IUSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:09:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:25957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2IUSJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,463,1344236400"; 
   d="scan'208";a="225002270"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [RFC v3 0/2] PCI-Express Non-Transparent Bridge Support 
Date: Fri, 21 Sep 2012 11:09:47 -0700
Message-Id: <1348250989-6962-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 of the patch that adds support for PCI-Express Non-Transparent 
Bridges in Linux.  This version incorporates changes to conform NTB and
client devices to the Linux device model (per Greg KH's request).  

Thanks,
Jon

