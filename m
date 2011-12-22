Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1LVBqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:45116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1LVBqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90216166"
Message-Id: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:14 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com, suresh.b.siddha@intel.com
Subject: [patch 0/5] x86: allow pre-enabled x2apic mode to be disabled
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous version of this patch and discussion can be found at
https://lkml.org/lkml/2011/12/16/488

Splitup the patch from Yinghai into multiple patches with minor changes
and other review comments (https://lkml.org/lkml/2011/12/20/27)

thanks,
suresh

