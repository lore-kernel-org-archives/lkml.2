Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1LBSnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:43:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:39895 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab1LBSnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,285,1320652800"; 
   d="scan'208";a="43370846"
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Add simple way to add statistic counters to debugfs
Date: Fri,  2 Dec 2011 10:43:24 -0800
Message-Id: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends debugfs to make it very simple to add per cpu counters
statistics that are exported there. This is useful for all kind
of debugging situations. The counters have very little overhead
and are simpler to use than trace points.

This is the infrastructure for debugfs and a demo application 
to instrument the dcache RCU which I developed some time ago
to track down some problems there.

Posting here also so that Fengguang can use it.

Module support is still missing, but could be added without too 
much work.

-Andi

