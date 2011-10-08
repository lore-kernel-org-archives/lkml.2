Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1JHGg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 02:36:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63083 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1JHGgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 02:36:53 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        Greg Kroah-Hartman <greg@kroah.com>, Ravishankar.km@greenturtles.in
Subject: [PATCH 0/4] Comedi: Checkpatch cleanup fix.
Date: Sat,  8 Oct 2011 12:05:56 +0530
Message-Id: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
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

