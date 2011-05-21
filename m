Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1EUA7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:59:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:46992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1EUA7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,245,1304319600"; 
   d="scan'208";a="1824589"
Message-Id: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 20 May 2011 17:51:16 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        gorcunov@openvz.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 0/4] x86, apic: apicdriver probe cleanups - V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patchset for cleaning up apic probe sequence by using apicdriver
section.

Changes from V1:
 * split up the patch into four small patches
 * misc cleanups, specifying section alignment, removing duplicate messages
   (from Cyrill and Yinghai's review comments)
 * fixed a crash on smaller x64 systems

