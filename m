Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0K1GKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:10:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:48306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0K1GK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,268,1288594800"; 
   d="scan'208";a="861974166"
Date: Sun, 28 Nov 2010 13:43:55 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3]mmc: enable runtime PM support for mmc storage card
Message-ID: <20101128054355.GA3318@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    These patches are to enable the runtime PM support for mmc storage cards. 

    Currently, there's already runtime PM support in the mmc core layer. But
    for the mmc storage card (SD card, mmc card, eMMC device and so on) to
    work with runtime PM, it also needs both block driver and host controller
    driver to implement the runtime PM support, which are not presented in
    current kernel.

    These patches implemented the runtime PM for both block driver and PCI
    interface SDHCI host controller driver. It also tried to fix some issues
    of current runtime PM implementation of mmc core layer.
