Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1ATR70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:59:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:22518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1ATR7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:59:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,352,1291622400"; 
   d="scan'208";a="377491634"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Mike Waychison <mikew@google.com>
Date: Thu, 20 Jan 2011 09:59:21 -0800
Subject: RE: [PATCH -v10 0/4] Lock-less list
Thread-Topic: [PATCH -v10 0/4] Lock-less list
Thread-Index: Acu4rCU6S1e2Fl5fQwytu+qwYy5I1gAHcoIg
Message-ID: <987664A83D2D224EAE907B061CE93D530194258DAE@orsmsx505.amr.corp.intel.com>
References: <1295484358.15213.25.camel@yhuang-dev>
 <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
 <20110120121455.GA7680@elte.hu>
 <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
 <20110120130625.GA14436@elte.hu> <20110120133621.GA314@a1.tnic>
 <20110120141143.GA17272@elte.hu>
In-Reply-To: <20110120141143.GA17272@elte.hu>
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

> > True story. And yet google folk still do that, unfortunately:
> > https://lkml.org/lkml/2011/1/10/419
>
> I wouldn't worry about that too much - such uses are extremely isolated.

Google is just one user - but they have (so I hear) a large number
of machines.

I would hazard a guess that there are other users that feel the
same way - i.e. users with a large number of machines that move
onto new kernel versions from time to time.

These users want a stable kernel->user ABI - and Google has stated
quite clearly that "printk" doesn't meet their need.  I think that
they would be happy with some other stable solution than mcelog,
but we might as well ask for their input before imposing something
on them.

Mike: would you like to join the conversation on how to report
errors - or nominate someone else to represent the Google point
of view?

-Tony


