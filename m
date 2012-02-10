Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab2BJNig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:38:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42043 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2BJNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:38:35 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/6] SEP resynchronize
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:52:13 +0000
Message-ID: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This picks out and regenerates the changes between Intel internal tree work
and the upstream kernel. The big things here are the additional access modes
and the reworking of the kernel crypto interface to the device.

With these added the tree divergence is basically some 64bit warning fixes
only in the upstream tree, a few debug statements and some Android specific
bits.

---

Mark A. Allyn (6):
      sep: reworked crypto layer
      sep: NULL out pointers, mark debug code DEBUG to fix warnings
      sep: update initialisation
      sep: Add interfaces for the new functions
      sep: Basic infrastructure for SEP DMA access to non CPU regions
      sep: Add new PCI identifier


 drivers/staging/sep/sep_crypto.c         | 3058 ++++++++++++++++--------------
 drivers/staging/sep/sep_crypto.h         |   77 -
 drivers/staging/sep/sep_dev.h            |    3 
 drivers/staging/sep/sep_driver_api.h     |   15 
 drivers/staging/sep/sep_driver_hw_defs.h |    3 
 drivers/staging/sep/sep_main.c           |  337 +++
 6 files changed, 2015 insertions(+), 1478 deletions(-)

--
     "Knowledge has no value or use for the solitary owner: to be
      enjoyed it must be communicated" -- Charles Pratt, 1st Earl Camden

