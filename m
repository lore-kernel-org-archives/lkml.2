Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab0IZF5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 01:57:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:45140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0IZF5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 01:57:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,237,1283756400"; 
   d="scan'208";a="328788746"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org
Subject: [PATHC 0/2] update and cleanup patches for coretemp etc.
Date: Sun, 26 Sep 2010 13:59:58 +0800
Message-Id: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] hwmon: uniform the init style of pkgtemp
[PATCH 2/2] hwmon: cleanup some hotplug related macro definition

These 2 patches are no new functions, just unify the codes to avoid
potential issues and some cleanup work.
