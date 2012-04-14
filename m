Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2DNQZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:25:14 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47566 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2DNQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:25:12 -0400
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 0/2] misc: randconfig patches for 3.3 kernel
Date: Sat, 14 Apr 2012 10:25:02 -0600
Message-Id: <1334420704-22079-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and have been reformatted for 3.3.

Arnd Bergmann (2):
  misc: add missing __devexit_p() annotations
  misc: do not mark exported functions __devexit

 drivers/misc/ad525x_dpot.c |    2 +-
 drivers/misc/bh1780gli.c   |    2 +-
 drivers/misc/pti.c         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.5.4

