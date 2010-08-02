Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0HBSlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:41:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:7467 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab0HBSlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,304,1278313200"; 
   d="scan'208";a="823995274"
Subject: Re: [PATCH] workqueue: mark init_workqueues() as early_initcall()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <4C55556C.6050206@kernel.org>
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
	 <4C55556C.6050206@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 02 Aug 2010 11:41:03 -0700
Message-Id: <1280774463.2703.6.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-01 at 12:07 +0100, Tejun Heo wrote:
> Audited and tested.  It should be fine.  Patch applied and pushed out
> to linux-next.  How shall we route the second patch?
> 

Tejun, v2 version of the second patch had both x86 and ia64 changes.

http://marc.info/?l=linux-kernel&m=128053714303108&w=2

So I am ok if you carry this with the rest of your workqueue changes
that touch these same files.

thanks,
suresh

