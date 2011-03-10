Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1CJGyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:54:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:41768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1CJGyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:54:18 -0500
Subject: Re: [PATCH/v2] mm/memblock: Properly handle overlaps and fix error
 path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110310064614.GE9289@elte.hu>
References: <1299466980.8833.973.camel@pasglop>
	 <4D77E5E0.6010706@kernel.org> <1299705610.22236.390.camel@pasglop>
	 <20110310064614.GE9289@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 17:53:38 +1100
Message-ID: <1299740018.22236.469.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 07:46 +0100, Ingo Molnar wrote:
> > Ah interesting, so you did have a case of overlap that wasn't properly
> > handled as well.
> > 
> > If there is no objection, I'll queue that up in powerpc-next for the
> > upcoming merge window (soon now).
> 
> I think it would be better to do it via -mm, as x86 and other architectures are now 
> affected by memblock changes as well. 

No objection, Andrew, are you picking this up ?

Cheers,
Ben.


