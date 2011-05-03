Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1ECSSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:18:03 -0400
Received: from mail.perches.com ([173.55.12.10]:1187 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1ECSSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:18:01 -0400
From: Joe Perches <joe@perches.com>
To: Oliver Neukum <oneukum@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] usbnet: style cleaning and logging
Date: Tue,  3 May 2011 11:17:56 -0700
Message-Id: <cover.1304445019.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a spring cleaning for the new maintainer to deal with...

Joe Perches (2):
  usbnet: Style cleanups
  usbnet: Convert dbg to dev_dbg and neatening.

 drivers/net/usb/usbnet.c |  638 +++++++++++++++++++++++-----------------------
 1 files changed, 325 insertions(+), 313 deletions(-)

-- 
1.7.5.rc3.dirty

