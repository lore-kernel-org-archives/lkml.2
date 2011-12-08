Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1LHS6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:58:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:26948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab1LHS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:58:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="85092086"
From: Andi Kleen <andi@firstfloor.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] NUMA x86: add constraints check for nid parameters
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
	<20111201133451.5fc1ee7b.akpm@linux-foundation.org>
	<20111201231441.GA3293@stainedmachine.redhat.com>
	<20111201152851.7e39f034.akpm@linux-foundation.org>
	<20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
	<alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
	<20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
Date: Thu, 08 Dec 2011 10:58:27 -0800
In-Reply-To: <20111207194311.GB26060@dhcp-27-244.brq.redhat.com> (Petr
	Holasek's message of "Wed, 7 Dec 2011 20:43:12 +0100")
Message-ID: <m2mxb2nb58.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Holasek <pholasek@redhat.com> writes:

> This patch adds constraints checks for numa_set_distance()
> function. It emits warning when pxms are used uninitialized
> when parsing the SRAT.

Can you expand on the motivation for this please?
Is this to catch buggy code or to catch buggy SRATs?
If the later are they actually out there?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
