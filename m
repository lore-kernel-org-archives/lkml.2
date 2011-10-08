Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1JHG3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 02:29:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43437 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1JHG3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 02:29:07 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: ravishankar.km@greenturtles.in
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        devel@driverdev.osuosl.org, wfp5p@virginia.edu,
        Ravishankar.km@greenturtles.in
Subject: [PATCH 0/4] Comedi: Checkpatch cleanup fix.
Date: Sat,  8 Oct 2011 11:58:23 +0530
Message-Id: <1318055303-3442-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Fix a warning issues find while running a checkpatch tool.

Ravishankar Karkala Mallikarjunayya (3):
      Staging: comedi: fix printk issue in cb_pcidas.c
      Staging: comedi: fix printk issue in cb_pcidas64.c
      Staging: comedi: fix printk issue in cb_pcimdas.c

drivers/staging/comedi/drivers/cb_pcidas.c   |   14 +++------
drivers/staging/comedi/drivers/cb_pcidas64.c |   24 +++++----------
drivers/staging/comedi/drivers/cb_pcimdas.c  |   39 +++++++++----------------
3 files changed, 27 insertions(+), 50 deletions(-)
---
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@driverdev.osuosl.org
Cc: wfp5p@virginia.edu
Cc: Ravishankar.km@greenturtles.in	
--- 
1.7.6.4

