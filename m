Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0F2SK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:10:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44385 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0F2SK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WryZ9s9qx0SaLtTUzLNKvhdkgSxTYfVK5CrrswS2Mq3UCRgvgbG7MDjC/5MgdT62Ex
         2ndW8gKAVgYGdrK3VPs1r361JvsaL2r0oLR3iXJX0MPTWzU2XRT29sf6ih3kD8jbdiUl
         Jcbr08Vd25h5w/SM86bxRj/ptLptFMlRsko9k=
Date: Tue, 29 Jun 2010 20:11:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
Message-ID: <20100629181104.GC11967@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.993794468@chello.nl> <20100629145806.GE5318@nowhere> <1277823591.1868.43.camel@laptop> <20100629150305.GG5318@nowhere> <1277829250.1868.46.camel@laptop> <20100629180745.GA11967@nowhere> <1277834950.1868.56.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277834950.1868.56.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 08:09:10PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-29 at 20:07 +0200, Frederic Weisbecker wrote:
> > On Tue, Jun 29, 2010 at 06:34:10PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2010-06-29 at 17:03 +0200, Frederic Weisbecker wrote:
> > > > > You mean, if (!pmu->start_txn && pmu->pmu_enable) { /* install defaults
> > > > > */ } ?
> 
> > neglected pmu implementations shouldn't impact software pmus.
> 
> With the above and not providing ->pmu_enable you get that.


But we don't need to provide a pmu_enable for software events, right?

