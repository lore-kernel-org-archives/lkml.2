Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0CYSoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:44:21 -0400
Received: from av6-2-sn3.vrr.skanova.net ([81.228.9.180]:33609 "EHLO
	av6-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0CYSoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:44:20 -0400
Subject: [PATCH 0/2] mfd, dma: Add timb-dma driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 19:44:16 +0100
Message-ID: <1269542656.9188.37.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow are two patches.

Samuel and Dan, since the MFD patch relies on the DMA patch.
The MFD patch is against Samuels next tree, maybe it is easiest
if the DMA driver is merged via Samuels tree?

The first patch adds the timb-dma driver to the dma tree.

The second one adds a timb-dma platform device to all
configurations of the timberdale MFD driver.

--Richard

