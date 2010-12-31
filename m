Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab0LaFsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:48:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0LaFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cyy4rSyDREYKy9BeSB6L0r3oFC98HgViBlbF4tEHxEvsOD2MQQpdpwei0feSrsfWVy
         JYCKScFABDNHHtInr2Jvo/rwFfjhSBIrXRobJlDg+AOxYti+7zUMpxKxCL0blxRtOMqh
         Xgt0PlVwdOUQZLwB8NShXx2FqtfoXZ/CPQW+k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 00/15]staging:rtl8187se trivial fix typos in comments. 
Date: Thu, 30 Dec 2010 21:48:36 -0800
Message-Id: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





Below is a set of patches that fix some comments in either a typo or makes the comment
more understanding(from the best that I can decipher).. 
Please let me know if there is anything I missed, and I'll fix it up
and resend.

 drivers/staging/rtl8187se/ieee80211/dot11d.c       |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   10 ++--
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    4 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   58 ++++++++++----------
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |    6 +-
 drivers/staging/rtl8187se/r8180_93cx6.h            |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   38 +++++++-------
 drivers/staging/rtl8187se/r8180_dm.c               |   24 ++++----
 drivers/staging/rtl8187se/r8180_hw.h               |    8 ++--
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    4 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    4 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    8 ++--
 15 files changed, 88 insertions(+), 88 deletions(-)


Justin P. Mattock
