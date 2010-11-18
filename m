Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0KRDG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:06:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:40460 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab0KRDG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:06:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,214,1288594800"; 
   d="scan'208";a="350199712"
Date: Thu, 18 Nov 2010 11:04:11 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com
Subject: [PATCH v3 0/2]MMC:implement eMMC4.4 standard HW reset feature
Message-ID: <20101118030411.GA10621@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,
	  These are the version 3 of HW reset feature implementation. Since I
	  didnot get any response from the version 2 and version1 patches, I am
	  not sure whether I need to change. So just did a little change in
	  form.

	  The 2 patches implemented eMMC4.4 hardware reset feature in core layer
	  and sdhci host layer, but need each sdhci host controller to implement
	  the real reset part specially.

	  patch 0001: implemented eMMC4.4 hardware reset feature in mmc core
	  layer. Added reinit callback in mmc_bus_ops and hardware_reset
	  callback in mmc_host_ops.
	  patch 0002: implemented hardware reset callback in sdhci host layer.
	  Added reset_emmc callback in sdhci_ops.

	  changelog:
	  patch 0001: add a error check when switch to enable HW reset bit
	  failed. Also add some comment to explain the added 2 new callbacks.
	  patch 0002: add some comment to explain the reset_emmc callback.

Thanks
Chuanxiao
