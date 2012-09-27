Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2I0WnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:43:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:31522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2I0Wm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="227869414"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [RFC v4 0/2] PCI-Express Non-Transparent Bridge Support 
Date: Thu, 27 Sep 2012 15:42:52 -0700
Message-Id: <1348785774-12607-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 4 of the patch that adds support for PCI-Express Non-Transparent
Bridges in Linux.  This version removes the transport transmit tasklet
(per Dave Miller's request).

Thanks,
Jon

