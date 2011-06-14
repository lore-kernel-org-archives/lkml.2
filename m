Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1FNJAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:00:51 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:13705 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1FNJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:00:50 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v5 0/5] GPIO: pca953x.c: Fix IRQ support and OF device-tree bindings
Date: Tue, 14 Jun 2011 11:00:53 +0200
Message-Id: <1308042058-20107-1-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes IRQ support and cleans up OF device-tree support for
the PCA953X gpio driver.
This is version 5 of the patch series.

Changes in this version:
 - new: GPIO: pca953x.c: Remove dynamic platform data pointer
 - Reverted completely removing of device-tree binding properties, and
   deprecated them instead issueing WARN() if they are used.

David Jander (5):
  GPIO: pca953x.c: Fix IRQ support.
  GPIO: pca953x.c: Remove dynamic platform data pointer
  GPIO: pca953x.c: Deprecate meaningless device-tree bindings
  GPIO: pca953x.c: Interrupt pin is active-low
  GPIO: pca953x.c: Fix warning of enabled interrupts in handler

 drivers/gpio/pca953x.c |  103 ++++++++++++++++++++++--------------------------
 1 files changed, 47 insertions(+), 56 deletions(-)

-- 
1.7.4.1

