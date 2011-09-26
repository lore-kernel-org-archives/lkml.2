Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1IZJbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:31:06 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:56993 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1IZJbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:31:04 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/4] [RESEND v6] VME Framework Fixes
Date: Mon, 26 Sep 2011 11:27:14 +0200
Message-ID: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I start by apologizing for my absence recently as I was away on vacation
for a few weeks. Picking up where I left off, this is the resend of the
two final patches along with some movement of code into additional patches.

Martyn, Emilio: Thanks for all the feedback :-)

Thanks!
Manohar

Manohar Vanga (4):
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support
  staging: vme: get rid of struct vme_device_id and slots
  staging: vme_user: rename USER_BUS_MAX to VME_USER_BUS_MAX

 drivers/staging/vme/devices/vme_user.c |   67 +++-----
 drivers/staging/vme/devices/vme_user.h |    2 +-
 drivers/staging/vme/vme.c              |  284 +++++++++++++++-----------------
 drivers/staging/vme/vme.h              |   50 ++++--
 drivers/staging/vme/vme_api.txt        |   90 ++++++-----
 drivers/staging/vme/vme_bridge.h       |    6 +-
 6 files changed, 246 insertions(+), 253 deletions(-)

-- 
1.7.4.1

