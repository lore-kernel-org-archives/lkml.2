Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2EaSp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:45:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:48812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab2EaSpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="146732866"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aA///7NhCAAH/JAP//mExA
Date: Thu, 31 May 2012 18:14:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F6CE1@ORSMSX104.amr.corp.intel.com>
References: <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com>
 <20120531172018.GO14515@aftab.osrc.amd.com>
In-Reply-To: <20120531172018.GO14515@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, thus the dynamic granularity. But we're going to end up reporting
> rank and row too so that it can be matched to the DIMM. I consider
> physical address a bonus in such cases and it is only of importance to
> those who like to replace single DRAM chips or single MOSFET transistors
> :-) :-) :-).

Perhaps you don't really need to replace your 32GB DIMM because a single
bit is stuck (one bad bit out of > 300 billion). With the physical address
we can tell Linux to try to stop using the page that contains the stuck
bit - most of the time it can do that.

-Tony
