Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1HWWmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:42:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1HWWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:04 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: [PATCH 0/8] [RESEND] staging: et131x: Code cleanups 
Date: Tue, 23 Aug 2011 23:40:32 +0100
Message-Id: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested, resend patches not applied yet to staging-next, plus one new patch.

Mark Einon (8):
[PATCH 1/8] [RESEND] staging: et131x: Remove unecessary *etdev NULL check in
[PATCH 2/8] [RESEND] staging: et131x: Converting et1310_tx.c function and
[PATCH 3/8] [RESEND] staging: et131x: Converting et1310_adapter.h variable
[PATCH 4/8] [RESEND] staging: et131x: Removing commented out code implemented
[PATCH 5/8] [RESEND] staging: et131x: Rename var name 'etdev' to 'adapter'
[PATCH 6/8] [RESEND] staging: et131x: Fix link detection signalling
[PATCH 7/8] [RESEND] staging: et131x: Fix free IRQ from IRQ context warning
[PATCH 8/8] staging: et131x: Update tx trans_start on device close

 drivers/staging/et131x/et1310_eeprom.c  |   32 +-
 drivers/staging/et131x/et1310_mac.c     |  243 ++++++++--------
 drivers/staging/et131x/et1310_phy.c     |  404 +++++++++++++--------------
 drivers/staging/et131x/et1310_pm.c      |   44 ++--
 drivers/staging/et131x/et1310_rx.c      |  188 +++++++------
 drivers/staging/et131x/et1310_tx.c      |  464 +++++++++++++++----------------
 drivers/staging/et131x/et131x.h         |    2 +-
 drivers/staging/et131x/et131x_adapter.h |   95 +++----
 drivers/staging/et131x/et131x_initpci.c |  157 +++++------
 drivers/staging/et131x/et131x_isr.c     |   52 ++--
 drivers/staging/et131x/et131x_netdev.c  |  132 +++++----
 11 files changed, 892 insertions(+), 921 deletions(-)

