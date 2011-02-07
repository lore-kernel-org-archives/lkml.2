Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1BGT6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:58:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:23953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1BGT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292943"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 0/6] IFX6X60 patchset : 02/07/2011
Date: Mon,  7 Feb 2011 12:02:26 -0800
Message-Id: <1297108952-27371-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello SPI/Serial Maintainers,

I am sending a patchset for the ifx6x60 driver to be considered for
inclusion in the Linux kernel.
Patches were made against the following GIT repo
http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
pull date: ~2/4/2011
A breif description of the patches follows:

[PATCH 1/6] serial: ifx6x60: fixed call to tty_port_init
       - fixed order of setting port ops
[PATCH 2/6] serial: ifx6x60: dma_alloc_coherent must use parent dev
       - fixed device for which the allocation is made
[PATCH 3/6] serial: ifx6x60: changed internal bpw from boolean to int
[PATCH 4/6] serial: ifx6x60: set SPI max_speed_hz based on platform type
       - set max speed based on platform data
[PATCH 5/6] serial: ifx6x60: probe routine needs to call spi_setup
       - configured spi for the h/w device
[PATCH 6/6] serial: ifx6x60: cleanup
