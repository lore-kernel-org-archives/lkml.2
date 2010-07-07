Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0GGNVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:21:07 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:45458 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab0GGNVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:21:05 -0400
From: Thibaut Girka <thib@sitedethib.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Smedia Glamo 3362 drivers
Date: Wed,  7 Jul 2010 15:12:02 +0200
Message-Id: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those drivers provide MMC and display functionalities of the Smedia Glamo 3362,
a multi-function device used in the Neo FreeRunner.

First patch is for the glamo core driver, needed for every other driver.
The second is for MMC support.
The third is for the GPIO interface.
The last one is for the framebuffer driver. In the case of the FreeRunner,
it is only useful with the glamo-gpio driver.
