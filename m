Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1LEWSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:18:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:29233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab1LEWSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:18:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,301,1320652800"; 
   d="scan'208";a="82478660"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Date: Mon, 5 Dec 2011 14:18:26 -0800
Subject: RE: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Topic: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Index: AcyzUGSzPP5UflE8TW2BPahHz37rwAASvgdg
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
In-Reply-To: <20111205131825.GA31275@gere.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a sane improvement, Tony I'm assuming you're handling this?

I can push this - but it would be nice to have some other comments from
outside of Intel (we've been beaten up written-by Intel, acked-by: Intel
too many times).

Can I count that as an "Acked-by:"?

-Tony

