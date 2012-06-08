Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab2FHVpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:45:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:14373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934490Ab2FHVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="150325265"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, linux-kernel@vger.kernel.org
Subject: Updated Ivybridge perf patchkit for tip perf/core
Date: Fri,  8 Jun 2012 14:45:26 -0700
Message-Id: <1339191928-13223-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- ported to tip perf/core
- fixed some comments
- Extra PEBS event not added so far because there's some doubt on the 
SDM version.

-Andi
