Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0JHFvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:51:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:3282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab0JHFvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,301,1283756400"; 
   d="scan'208";a="614564573"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, guenter.roeck@ericsson.com,
        linux-kernel@vger.kernel.org
Subject: update and cleanup patches for core{pkg, via}temp etc.
Date: Fri,  8 Oct 2010 13:53:34 +0800
Message-Id: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V2 1/2] hwmon: uniform the init style of pkgtemp
[PATCH V2 2/2] hwmon: cleanup some hotplug related macro definition

These 2 patches don't supply new functions, just unify the codes to avoid
potential issues and some cleanup work.

V2: fix some compile errors.

