Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab1LNRWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:22:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:40324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1LNRWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:22:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87278806"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Wed, 14 Dec 2011 09:21:54 -0800
Subject: RE: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Thread-Topic: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Thread-Index: Acy6gWc4bQpkTvAIQZapjs0crrqLLQAAwvNg
Message-ID: <0207C53569FE594381A4F2EB66570B2A019147EF6A@orsmsx508.amr.corp.intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
 <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
 <20111214074749.GD25232@elte.hu> <20111214160702.GH23589@aftab>
 <20111214165459.GB32305@elte.hu>
In-Reply-To: <20111214165459.GB32305@elte.hu>
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

> > >  	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
> > 
> > Btw., while at it, could we phrase this message in a more 
> > obvious way to users, such as 'Non-fatal memory failure at 
> > %lx ignored'?
> 
> Yeah, that's might not be as correct as we want it to be. AO 
> means it is an uncorrectable error, i.e. it will become fatal 
> if we'd consumed it, but it isn't that now because we just saw 
> it passing by in the cacheline...
> 
> Maybe "Fatal, unconsumed error ignored..."

The overall meaning is "land mine seen but not stepped on yet"

I'll see if I can wordsmith the message to convey that.

-Tony
