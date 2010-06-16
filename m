Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0FPSKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:10:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0FPSKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:10:31 -0400
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1276710480.1745.608.camel@laptop>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.241599593@chello.nl>  <20100616170354.GA5530@nowhere>
	 <1276710480.1745.608.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 20:10:22 +0200
Message-ID: <1276711822.1745.613.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 19:48 +0200, Peter Zijlstra wrote:
> > > +static int perf_swevent_int(struct perf_event *event)
> > > +{
> > > +   if (event->attr.type != PERF_TYPE_SOFTWARE)
> > > +           return -ENOENT
> > 
> > 
> > perf_swevent_init() ?
> 
> copy/paste gone wild.. 

/me learns how to read again,.. D'0h!
