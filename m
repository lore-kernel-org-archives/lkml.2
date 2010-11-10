Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0KJSXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:23:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:51703 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab0KJSXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:23:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,179,1288594800"; 
   d="scan'208";a="856215242"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 10 Nov 2010 10:23:08 -0800
Subject: RE: [RFC/Requirements/Design] h/w error reporting
Thread-Topic: [RFC/Requirements/Design] h/w error reporting
Thread-Index: AcuBAe6uJPjqEUAzRQSNEqWOwPQSRwAAi+WA
Message-ID: <987664A83D2D224EAE907B061CE93D5301649A6F7B@orsmsx505.amr.corp.intel.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>  <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
In-Reply-To: <1289412329.12418.177.camel@gandalf.stny.rr.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A few of things that pop up quickly are:
>
> 1) lockless

This is a clear requirement for use in h/w error
reporting too.  Taking locks in NMI or machine
check handler isn't an option.

-Tony
