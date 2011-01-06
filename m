Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1AFAES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:31905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AFAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833857"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 0/7] IFX6X60 patchset: 01/05/2011
Date: Wed,  5 Jan 2011 16:05:06 -0800
Message-Id: <1294272313-15899-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello SPI/Serial Maintainers,

I am sending a patchset for the ifx6x60 driver to be considered for
inclusion in the Linux kernel.
Patches were made against the following GIT repo
http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
A breif description of the patches follows:

[PATCH 1/7] serial: ifx6x60: fixed call to tty_port_init
       - fixed order of setting port ops
[PATCH 2/7] serial: ifx6x60: dma_alloc_coherent must use parent dev
       - fixed device for which the allocation is made
[PATCH 3/7] serial: ifx6x60: changed internal bpw from boolean to int
[PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on platform type
       - set max speed to 25Mhz for platforms that support it
[PATCH 5/7] serial: ifx6x60: probe routine needs to call spi_setup
       - configured spi for the h/w device
[PATCH 6/7] serial: ifx6x60: fix modem names to ones recognized by firmware
[PATCH 7/7] serial: ifx6x60: cleanup
