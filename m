Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0KJTAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:00:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0KJTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:00:47 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ihwcKYQO0XAs4WW6YrgA:9 a=9m-7Pw_H7H41oiNILyzuO5M_EEMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101110184105.GH22410@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
	 <1289413460.2084.27.camel@laptop>  <20101110184105.GH22410@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 14:00:45 -0500
Message-ID: <1289415645.12418.180.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:

> We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
> As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
> and will do better here.

Thus you are saying that we stick to the status quo, and also ignore the
fact that perf was a rewrite-the-world from ftrace to begin with.

-- Steve


