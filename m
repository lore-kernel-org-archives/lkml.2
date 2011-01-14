Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1ANB0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:26:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52699 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1ANB0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:26:03 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: 
Date: Thu, 13 Jan 2011 19:14:53 -0600
Message-Id: <1294967693-1938-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these changes for 2.6.38:

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git for-gkh-2.6.38

Guzman Lugo, Fernando (1):
      staging: tidspbridge: configure full L1 MMU range

Omar Ramirez Luna (1):
      staging: tidspbridge: replace mbox callback with notifier_call

 drivers/staging/tidspbridge/core/tiomap3430.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

Regards,

Omar
