Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0FGJsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:48:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FGJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:48:10 -0400
Subject: Re: [PATCH -tip] perf, x86: Make a second write to performance
 counter if needed
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100602212304.GC5264@lenovo>
References: <20100602212304.GC5264@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:48:05 +0200
Message-ID: <1275904085.1645.555.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 01:23 +0400, Cyrill Gorcunov wrote:
> On Netburst PMU we need a second write to a performance counter
> due to cpu erratum.
> 
> A simple flag test instead of alternative instructions was choosen
> because wrmsrl is already a macro and if virtualization is turned
> on will need an additional wrapper call which is more expencise.
> 
> nb: we should propably switch to jump-labels as only this facility
> reach the mainline.

OK. Thanks Cyrill.


