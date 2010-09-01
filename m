Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0IADAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab0IADA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:00:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] lockup detector fixes
Date: Tue, 31 Aug 2010 23:00:06 -0400
Message-Id: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of fixes for the lockup detector.

Tested on intel/amd on top of ingo's tip branch.

Akinobu Mita (2):
  lockup_detector: convert cpu notifier to return encapsulate errno
    value
  lockup_detector: remove unnecessary panic_notifier

Don Zickus (1):
  [lockup detector] sync touch_*_watchdog back to old semantics

 kernel/watchdog.c |   53 +++++++++++++++++++++++------------------------------
 1 files changed, 23 insertions(+), 30 deletions(-)

-- 
1.7.2.2

