Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2BWEpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:45:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12870 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BWEpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:45:17 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-56-4f45c45b93ca
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH 0/2] power_supply: update Charger-Manager
Date: Thu, 23 Feb 2012 13:44:58 +0900
Message-id: <1329972300-19335-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially, the main role of Charger-Manager is to monitor battery health
while the system is in suspend-to-RAM.

This patchset updates the initial Charger-Manager to
poll the battery state in normal state and
provide function for in-kernel use.

Donggeun Kim (2):
  power_supply: Charger-Manager: poll battery health in normal state
  power_supply: Charger-Manager: provide function for in-kernel use

 Documentation/power/charger-manager.txt |   41 +++-
 drivers/power/charger-manager.c         |  387 +++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |   43 ++++
 3 files changed, 469 insertions(+), 2 deletions(-)

-- 
1.7.4.1

