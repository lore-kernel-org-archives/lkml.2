Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1GIGU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:20:29 -0400
Received: from mail.perches.com ([173.55.12.10]:3688 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1GIGU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:20:28 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add missing commas
Date: Fri,  8 Jul 2011 23:20:22 -0700
Message-Id: <cover.1310187270.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch to staging/gma500 found a missing comma in
arrays declarations.  Here are some others.

Joe Perches (3):
  benet: Add missing comma between constant string array
  iwlegacy: Add missing comma between constant string array
  iwlagn: Add missing comma between constant string array

 drivers/net/benet/be_main.c                  |    6 +++---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.7.6.131.g99019

