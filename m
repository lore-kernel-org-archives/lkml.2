Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1FERfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:35:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64805 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1FERfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ceZrisK8PmpMrRGAKfEuo7S4NStuGw5IzXv48/SGcVgylcv2l3mPrGfCtaKBzJSYyP
         pYv1vy4ugzx8a58nEW3WgeRpL5hBi8aetnf8H2ujQqP5fVV2IvJjwDE/YAI94p577nM5
         J6uVyp1t0dOGJFqMLCFlntc2xHNhEvrtmFK+A=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: [PATCH 0/5] staging: et131x: checkpatch fixes
Date: Sun,  5 Jun 2011 18:35:15 +0100
Message-Id: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have been build-tested only.

Mark Einon(5):
 staging: et131x: et1310_address_map.h checkpatch fixes
 staging: et131x: et1310_rx.c checkpatch fixes
 staging: et131x: et131x_adapter.h checkpatch fixes
 staging: et131x: et131x_initpci.c checkpatch fixes
 staging: et131x: et131x_netdev.c checkpatch fixes

 drivers/staging/et131x/et1310_address_map.h |   62 +++++-----
 drivers/staging/et131x/et1310_mac.c         |   26 ++--
 drivers/staging/et131x/et1310_phy.c         |    6 +-
 drivers/staging/et131x/et1310_rx.c          |  193 +++++++++++++--------------
 drivers/staging/et131x/et131x_adapter.h     |   10 +-
 drivers/staging/et131x/et131x_initpci.c     |   29 ++--
 drivers/staging/et131x/et131x_isr.c         |    2 +-
 drivers/staging/et131x/et131x_netdev.c      |  114 +++++++---------
 8 files changed, 216 insertions(+), 226 deletions(-)

