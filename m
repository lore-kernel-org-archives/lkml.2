Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2AXXgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:36:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46062 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753314Ab2AXXgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:36:02 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] thermal_sys: Cleanups
Date: Tue, 24 Jan 2012 15:35:34 -0800
Message-Id: <cover.1327447797.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  thermal_sys: Remove unnecessary line continuations
  thermal_sys: Remove obfuscating used-once macros
  thermal_sys: Kernel style cleanups
  thermal_sys: Convert printks to pr_<level>

 drivers/thermal/thermal_sys.c |   87 +++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 51 deletions(-)

-- 
1.7.8.111.gad25c.dirty

