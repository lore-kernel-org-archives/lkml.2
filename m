Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0LFMnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:43:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:6782 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0LFMnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208";a="684317230"
Date: Mon, 6 Dec 2010 20:15:48 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3]mmc: enable runtime PM support for mmc storage card
Message-ID: <20101206121548.GA30654@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    These are the version 2 patches to enable the runtime PM support for mmc
    storage cards.

    Ohad Ben-Cohen has gave very good comments on the version 1 patches. And
    now the version 2 patches tries to fix the problems identified by Ohad.

    Currently, there's already runtime PM support in the mmc core layer. But
    for the mmc storage card (SD card, mmc card, eMMC device and so on) to
    work with runtime PM, it also needs both block driver and host controller
    driver to implement the runtime PM support, which are not presented in
    current kernel.

    These patches implemented the runtime PM for both block driver and PCI
    interface SDHCI host controller driver. It also tried to fix some issues
    of current runtime PM implementation of mmc core layer.

