Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1CAQrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:47:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:52053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab1CAQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:47:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,248,1297065600"; 
   d="scan'208";a="714758886"
Subject: [PATCH v2 0/4] perf: offcore event monitoring patches
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 00:47:50 +0800
Message-Id: <1298998070.2170.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the updated offcore patches. I merged small changes and fixes
into the first patch, see the change logs.

Change logs against Andi's original version:
- Extends perf_event_attr:config to config{,1,2} (Peter Zijlstra)
- Fixed a major event scheduling issue. There cannot be a ref++ on an
event that has already done ref++ once and without calling
put_constraint() in between. (Stephane Eranian)
- Use thread_cpumask for percore allocation. (Lin Ming)
- Use MSR names in the extra reg lists. (Lin Ming)

Peter,
The event scheduling issue was fixed, could you please consider merging
this series?

Thanks,
Lin Ming 

