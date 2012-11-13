Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2KMSKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:10:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57096 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab2KMSKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:10:31 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <b-cousson@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 0/5] staging: omap-thermal fixes
Date: Tue, 13 Nov 2012 14:09:59 -0400
Message-ID: <1352830204-21546-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again Greg,

So here is the correct set of changes. They now include the
right version of the patches and with the fixes reported
by Enric. Thanks Enric for the heads up.

So, Several compilation fixes and a couple of debugging prints
added to the omap-thermal driver under staging area.

Patches are also available here:

git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes_3.7


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
 3 files changed, 33 insertions(+), 108 deletions(-)

-- 
1.7.7.1.488.ge8e1c

