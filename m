Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab1COUWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:22:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:46379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab1COUWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,190,1299484800"; 
   d="scan'208";a="613364723"
From: "Luck, Tony" <tony.luck@intel.com>
To: Milton Miller <miltonm@bga.com>, Peter Zijlstra <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Anton Blanchard <anton@samba.org>,
        "xiaoguangrong@cn.fujitsu.com" <xiaoguangrong@cn.fujitsu.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "efault@gmx.de" <efault@gmx.de>, Jan Beulich <JBeulich@novell.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Mar 2011 13:22:31 -0700
Subject: RE: [PATCH 0/4 v3] smp_call_function_many issues from review
Thread-Topic: [PATCH 0/4 v3] smp_call_function_many issues from review
Thread-Index: AcvjRwkQ9MWNBksjRQOgDwpnE4HbkQAB2/Zg
Message-ID: <987664A83D2D224EAE907B061CE93D53019DC07EB3@orsmsx505.amr.corp.intel.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
 	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>	 <ipi-list-reply@mdm.bga.com>
	 <smp-cfm-list-comment@mdm.bga.com>
	 <smp-call-function-list-race-fix-v2@mdm.bga.com>
	 <20110201220026.GD2142@linux.vnet.ibm.com>	 <ipi-paul-reply@mdm.bga.com>
	 <20110202041740.GB2129@linux.vnet.ibm.com>
	 <20110206235136.GA23658@linux.vnet.ibm.com>
 <smp-call-function-intro-v3@mdm.bga.com>
In-Reply-To: <smp-call-function-intro-v3@mdm.bga.com>
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

> Dimitri or Tony, let me know if you would like a revert patch for
> 75c1c91c to be added after patch 3.

It appears that we won't need this anymore, so sure - revert it.

-Tony
