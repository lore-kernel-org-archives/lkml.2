Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2KMPnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:43:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50172 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2KMPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:43:51 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <b-cousson@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/5] staging: omap-thermal fixes
Date: Tue, 13 Nov 2012 11:43:17 -0400
Message-ID: <1352821402-13458-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Several compilation fixes and a couple of debugging prints
added to the omap-thermal driver under staging area.

Patches are also available here:

git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes

Cheers,

Eduardo Valentin (4):
  staging: omap-thermal: fix compilation
  staging: omap-thermal: remove platform data nomenclature
  staging: omap-thermal: remove freq_clip table
  staging: omap-thermal: add IRQ debugging messaging

Radhesh Fadnis (1):
  staging: omap-thermal: fix context restore function

 drivers/staging/omap-thermal/omap-bandgap.c        |   63 ++++++++----------
 drivers/staging/omap-thermal/omap-bandgap.h        |    9 ---
 drivers/staging/omap-thermal/omap-thermal-common.c |   69 ++------------------
 3 files changed, 34 insertions(+), 107 deletions(-)

-- 
1.7.7.1.488.ge8e1c

