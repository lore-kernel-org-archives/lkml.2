Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2KFALW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:11:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:61483 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2KFALU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:11:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,718,1344236400"; 
   d="scan'208";a="164848261"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v5 0/2] PCI-Express Non-Transparent Bridge Support 
Date: Mon,  5 Nov 2012 17:11:07 -0700
Message-Id: <1352160669-4330-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am submitting version 5 of the PCI-Express Non-Transparent Bridge
patches for inclusion in 3.8 via Greg KH's char-misc-next tree.  All
outstanding issues have been addressed.

Version 1
http://thread.gmane.org/gmane.linux.kernel.pci/16443

Version 2 incorporates numerous clean-ups
http://thread.gmane.org/gmane.linux.kernel.pci/16696

Version 3 incorporates changes to conform NTB and client devices to the
Linux device model (per Greg KH's request).
http://thread.gmane.org/gmane.linux.kernel.pci/17808

Version 4 removes the transport transmit tasklet (per Dave Miller's
request)
http://thread.gmane.org/gmane.linux.network/244491

Version 5 corrects a MSI-X bug and cleans up some comments 
http://thread.gmane.org/gmane.linux.kernel.pci/18030

Thanks,
Jon

