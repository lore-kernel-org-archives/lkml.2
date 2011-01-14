Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1ANI2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:28:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:63848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1ANI2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:28:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="374530046"
Date: Fri, 14 Jan 2011 16:22:55 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, ohad@wizery.com
Subject: [PATCH v1 0/3]mmc: add runtime pm for mmc host stack
Message-ID: <20110114082255.GA27523@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   These are the version 1 patches for enabling runtime power management for
   mmc host driver stack.

   Right now runtime pm in mmc driver stack can only care about the
   power of SDIO card, not the host controller. Host controller also needs
   runtime pm to save power.

   MMC host can let the host device go into runtime suspended state when
   there is no user request to deal, and wake up host device when there
   comes one. MMC driver will manage the power of host controller like this
   way.

   patch1: implemented runtime pm for mmc host
   patch2: implemented runtime pm for SDHCI host controller
   patch3: Do not let mmc host clock gated when host is in runtime suspended
   state.

Thanks
Chuanxiao
