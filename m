Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab1ESXre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:47:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:46429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab1ESXrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:47:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="4927355"
Message-Id: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 May 2011 16:45:45 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com
Subject: [patch 0/6] x86: x2apic cluster optimizations and apic probe cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Here is the updated patchset for optimizing IPI's in the
x2apic cluster mode aswell as clean the apic probe code by using
apicdriver section.

Previous version can be found at: https://lkml.org/lkml/2011/5/13/341

thanks,
suresh

