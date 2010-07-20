Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0GTW0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:26:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:27889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab0GTW0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="537316478"
Subject: Re: [PATCH 09/10] x86, xsave: check cpuid level for XSTATE_CPUID
 (0x0d)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-10-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-10-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:26:04 -0700
Message-Id: <1279664764.2899.54.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> The patch adds a check that tests if XSTATE_CPUID exists.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

While we are at this, can you please rename the other hardcoded 0xd's
with XSTATE_CPUID in xsave.c?

> + struct cpuinfo_x86 *c = &cpu_data(0);

Can we use boot_cpu_data instead of cpu_data(0).

thanks.

