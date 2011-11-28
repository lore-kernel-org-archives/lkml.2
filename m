Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1K1TzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:55:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63889 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1K1TzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:55:16 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        alan@linux.intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/4] MAX17042 add support for maxim POR procedure
Date: Mon, 28 Nov 2011 11:49:49 -0800
Message-Id: <1322509793-10800-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set adds support for the power on reset procedure for the
max17042 battery fuel gauge.  The accuracy of the fuel gauge is
improved by configuring the fuel gauge with the characterization data
for the battery present in the platform.



Dirk Brandewie (4):
  max17042: Move power suppply registration to a worker thread
  max17042: Align register definitions with data sheet and init appnote
  max17042: Add POR init procedure from Maxim appnote
  x86-mrst: Add battery fuel guage platform data

 arch/x86/platform/mrst/mrst.c          |   46 ++++
 drivers/power/max17042_battery.c       |  401 ++++++++++++++++++++++++++++++--
 include/linux/power/max17042_battery.h |   93 +++++++-
 3 files changed, 510 insertions(+), 30 deletions(-)

-- 
1.7.7.3

