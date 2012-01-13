Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2AMAgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:36:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:53986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab2AMAgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="55987992"
From: Huang Ying <ying.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, ying.huang@intel.com
Subject: x86, mce, Use user return notifier in mce
Date: Fri, 13 Jan 2012 08:36:39 +0800
Message-Id: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the home-made TIF_MCE_NOTIFY based code in MCE with user                
return notifier.

To make this possible, make user return notifier lockless firstly.

[RFC 1/2] urn, make user return notifier lockless
[RFC 2/2] x86, mce, Use user return notifier in mce
