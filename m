Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2EAGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:25:27 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53847 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2EAGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:26 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi: fix code cleanup issues.
Date: Tue,  1 May 2012 11:55:05 +0530
Message-Id: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   This set of patches fix a some coding style issues found by the 
   checkpatch tool.

regards,
Ravishankar K M 
 

Ravishankar Karkala Mallikarjunayya (5):
      Staging: comedi: fix line over 80 character issue in usbduxfast.c
      Staging: comedi: fix printk issue in pcmmio.c
      Staging: comedi: fix line indentation issue in dt9812.c
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: fix line over 80 character issue in rtd520.c


 drivers/staging/comedi/drivers/dt9812.c     |   23 +++++-----
 drivers/staging/comedi/drivers/pcmmio.c     |    2 +-
 drivers/staging/comedi/drivers/rtd520.c     |   62 ++++++++++++++++++---------
 drivers/staging/comedi/drivers/usbduxfast.c |   37 +++++++++-------
 4 files changed, 75 insertions(+), 49 deletions(-)
---











