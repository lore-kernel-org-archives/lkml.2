Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab1IAJSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:18:52 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:5672 "EHLO CERNMX31.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab1IAJSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:18:50 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/3] [RESEND v5] VME Framework Fixes
Date: Thu, 1 Sep 2011 11:15:23 +0200
Message-ID: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Martyn, Emilio,

This is the resend of the patches with additional code added to patch 3 to
remove devices in the case that a bridge driver is removed. (I don't know how
common it is to keep resending patchsets so I apologize for any noise I may
be causing).

Thanks
Manohar

Manohar Vanga (3):
  staging: vme: change static device array to pointers
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/bridges/vme_ca91cx42.c |    3 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    3 +
 drivers/staging/vme/devices/vme_user.c     |   67 +++----
 drivers/staging/vme/devices/vme_user.h     |    2 +-
 drivers/staging/vme/vme.c                  |  283 ++++++++++++++--------------
 drivers/staging/vme/vme.h                  |   56 ++++--
 drivers/staging/vme/vme_api.txt            |   79 +++++---
 drivers/staging/vme/vme_bridge.h           |    6 +-
 8 files changed, 263 insertions(+), 236 deletions(-)

-- 
1.7.4.1

