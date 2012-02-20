Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2BTJHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:07:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:4711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2BTJHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:07:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108566916"
From: Alex Shi <alex.shi@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, andiry.xu@amd.com,
        clemens@ladisch.de, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] enable pci MSI/MSIX in usb core
Date: Mon, 20 Feb 2012 17:05:30 +0800
Message-Id: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This e-mail thread is correct and latest patchset. sorry for several minutes
ago incorrect patches.

I clean up code and combind them into serial. The first one in already in
stable, list here just to show clear patch dependency.

The second one is main code to enable MSI/MSIX in usb core.

The third one is just for potential function usage. 

Thanks&Regards!

Alex

