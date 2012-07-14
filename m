Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2GNA6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:58:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:18189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab2GNA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="122164048"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Sandy Bridge pebs fix fixes
Date: Fri, 13 Jul 2012 17:58:12 -0700
Message-Id: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix Peter's rewrite of the pebs microcode patches to actually work
- Readd the early microcode update for onlined CPUs to close
the "early schedule user space" race that Peter pointed out originally.

-Andi

