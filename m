Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1CBM1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:27:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:42180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1CBM1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:27:32 -0500
Subject: Re: [PATCH v2 1/4] perf-events: Add support for supplementary
 event registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimBgKukb+aWP7supmTkF0RbTjmj-E49RtCnjUt7@mail.gmail.com>
References: <1298998076.2170.62.camel@localhost>
	 <AANLkTimvx+MYhOw8VFsJn4V6FQutKiYO6pHxgd9xGY8A@mail.gmail.com>
	 <1299026246.4937.99.camel@minggr.sh.intel.com>
	 <AANLkTi=a3_EE8RwdRTmhpcgGwq2fY8jXMC=s+zwh7_NE@mail.gmail.com>
	 <1299062041.1310.3.camel@laptop>
	 <AANLkTimBgKukb+aWP7supmTkF0RbTjmj-E49RtCnjUt7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 13:29:03 +0100
Message-ID: <1299068943.1310.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 13:07 +0100, Stephane Eranian wrote:

> > I initially put config and config0 in a union, but that made compilation
> > fail and fixing that up vs the benefit of actually having a config0,
> > which seemed near 0, led me to drop that part. Forgot to update the
> > comment though ;-)
> >
> Ok, but that's not committed yet, isn't it?


No I dropped all of that when you spotted a problem with the series.



