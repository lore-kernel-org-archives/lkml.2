Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2LUXIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:08:34 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63466 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2LUXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:08:33 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 0/3] staging: android: Minor changes - again.
Date: Sat, 22 Dec 2012 09:00:43 +1000
Message-Id: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg and others.

This is a small patch series to fix some checkpatch issues and add
some help documentation to Kconfig.

Sorry if I messed up - I haven't written Kconfig documentation before,
so I'm not quite sure if it has to be in a certain style.

Cruz Julian Bishop (3):
  staging: android: Avoid using camelcase in binder.h
  staging: android: Fix two checkpatch issues in binder.c
  staging: android: Add some Kconfig help entries

 drivers/staging/android/Kconfig  |   29 ++++++++++++++++++++++++++---
 drivers/staging/android/binder.c |    6 +++---
 drivers/staging/android/binder.h |    4 ++--
 3 files changed, 31 insertions(+), 8 deletions(-)

-- 
1.7.10.4

