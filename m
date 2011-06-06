Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1FFSHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:07:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1FFSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K5NsSEMCB6tC1tJC6FT+47hYf3A5LF277AE0xwchLtrSkVdygeSIQHAn/KR6UR+yd0
         72ypaDurZmDmI+DohHnET8dZ9T7/B7ab8Uac0r8niFXP3cqLV9h9NXJBOvYNOSLSrgOc
         MV0poPwc1UQ3VyH3tHdGxfY3qxFrQojfnSfEI=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH v2 0/7] staging: et131x: checkpatch fixes
Date: Mon,  6 Jun 2011 19:06:57 +0100
Message-Id: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have been build-tested only, and modified following suggestions by Alan Cox.

Mark Einon(5):
 staging: et131x: checkpatch fixes for
 staging: et131x: et1310_rx.c checkpatch fixes
 staging: et131x: et131x_adapter.h checkpatch fixes
 staging: et131x: et131x_initpci.c checkpatch fixes
 staging: et131x: et131x_netdev.c checkpatch fixes
 staging: et131x: Fixes multiple 'WARNING: do not add new typedefs'.
 staging: et131x: Removing '_t' from ce_stats_t struct

 drivers/staging/et131x/et1310_address_map.h |  201 ++++++++++----------------
 drivers/staging/et131x/et1310_mac.c         |  122 ++++++++--------
 drivers/staging/et131x/et1310_phy.c         |   12 +-
 drivers/staging/et131x/et1310_rx.c          |  203 +++++++++++++--------------
 drivers/staging/et131x/et1310_tx.c          |    8 +-
 drivers/staging/et131x/et131x.h             |    2 +-
 drivers/staging/et131x/et131x_adapter.h     |   10 +-
 drivers/staging/et131x/et131x_initpci.c     |   29 ++--
 drivers/staging/et131x/et131x_isr.c         |    6 +-
 drivers/staging/et131x/et131x_netdev.c      |  116 +++++++--------
 10 files changed, 325 insertions(+), 384 deletions(-)

