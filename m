Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0KJUy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:54:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:28176 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0KJUy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:54:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,180,1288594800"; 
   d="scan'208";a="856262813"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Date: Wed, 10 Nov 2010 12:54:21 -0800
Subject: RE: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Thread-Topic: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Thread-Index: AcuBFR4HY9Vavc6FS8ykVEXaAcJYqAAA4ybg
Message-ID: <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
References: <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
 <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu>
 <1289415645.12418.180.camel@gandalf.stny.rr.com>
 <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>
In-Reply-To: <20101110202316.GA32396@Krystal>
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

>- Perf does not support flight recorder tracing (concurrent read/write)
>  - Sub-buffers are needed to support concurrent read/writes

When I hear somebody say "flight recorder" - I think of "black boxes"
in airplanes that log data while the flight is running, and are only
looked at offline later.  So I'm confused by the "concurrent read/write"
requirement.

Perhaps you could explain the use cases of your "flight recorder",
because it seems that the name doesn't fit exactly, and this is
causing me (and maybe others) some confusion.

Thanks

-Tony
