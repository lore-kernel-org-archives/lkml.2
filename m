Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab0ENELV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:11:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52482 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0ENELU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:11:20 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 0/8] Suspend block api (version 7)
Date: Thu, 13 May 2010 21:11:05 -0700
Message-Id: <1273810273-3039-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a suspend-block api that provides the same
functionality as the android wakelock api. This version has some
changes from, or requested by, Rafael. The most notable changes are:
- DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
  for statically allocated suspend blockers. 
- suspend_blocker_destroy is now called suspend_blocker_unregister
- The user space mandatory _INIT ioctl has been replaced with an
  optional _SET_NAME ioctl.

I kept the ack and reviewed by tags on two of the patches even though
there were a few cosmetic changes.

--
Arve Hjønnevåg <arve@android.com>

