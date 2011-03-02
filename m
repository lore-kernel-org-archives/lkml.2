Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1CBVD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:03:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40393 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab1CBVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pax8BVSN0wP8/bmQphgIZC2GzzPBCX3gbA1U93qEiD3EqJ2ag9Y5ppMXVjdvmWZDq7
         ELiJdQzTAevrG/MAT3G1hxXNZXYgRP3Itnqcp4tpvZ2BZtODEeTQ29UpooN4h9APk+YW
         RcBpRfeY1JVpGGNpd4ODC2J8mFJEv9l1ArefA=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, acho@novell.com,
        error27@gmail.com, Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH 0/2] Staging: keucr: Patch set to remove all custom type from driver.
Date: Wed,  2 Mar 2011 22:03:50 +0100
Message-Id: <1299099830-1385-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>

 drivers/staging/keucr/common.h    |    9 -
 drivers/staging/keucr/init.c      |   54 +++---
 drivers/staging/keucr/init.h      |   18 +-
 drivers/staging/keucr/ms.c        |  208 ++++++++++----------
 drivers/staging/keucr/ms.h        |  262 +++++++++++++-------------
 drivers/staging/keucr/msscsi.c    |   76 ++++----
 drivers/staging/keucr/sdscsi.c    |   48 +++---
 drivers/staging/keucr/smil.h      |  128 ++++++------
 drivers/staging/keucr/smilecc.c   |   88 +++++-----
 drivers/staging/keucr/smilmain.c  |  156 ++++++++--------
 drivers/staging/keucr/smilsub.c   |  386 ++++++++++++++++++------------------
 drivers/staging/keucr/smscsi.c    |   32 ++--
 drivers/staging/keucr/transport.c |    4 +-
 drivers/staging/keucr/transport.h |   48 +++---
 drivers/staging/keucr/usb.c       |    4 +-
 drivers/staging/keucr/usb.h       |   84 ++++----
 16 files changed, 797 insertions(+), 808 deletions(-)
