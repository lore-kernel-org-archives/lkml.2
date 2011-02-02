Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1BBU5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:57:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:40687 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1BBU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:57:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="383371412"
From: Russ Gorby <russ.gorby@intel.com>
To: David Brownell <dbrownell@users.sourceforge.net> (maintainer:SPI
	SUBSYSTEM),
        Grant Likely <grant.likely@secretlab.ca> (maintainer:SPI SUBSYSTEM),
        spi-devel-general@lists.sourceforge.net (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011
Date: Wed,  2 Feb 2011 13:01:51 -0800
Message-Id: <1296680512-2758-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011>
References: <[PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello SPI maintainers,
I am sending a patch for the (new) intel_mid_ssp_spi driver for
consideration for inclusion in the Linux Kernel. This is a SPI master
controller driver that is being used for the intel MID platform (Medfield).
It uses the on-board Bulverde SSP controller configured for SPI (spibus #3)
running at 25Mhz.
