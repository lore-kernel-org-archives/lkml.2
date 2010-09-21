Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0IUDFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 23:05:36 -0400
Received: from ozlabs.org ([203.10.76.45]:33327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0IUDFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 23:05:33 -0400
Date: Tue, 21 Sep 2010 13:05:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH -tip -v5] irq_work: generic hard-irq context callbacks
Message-ID: <20100921030523.GB14668@drongo>
References: <1284689131.32373.63.camel@yhuang-dev>
 <1284728802.28028.470.camel@twins>
 <20100920042011.GA13542@drongo>
 <1284973981.2275.642.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284973981.2275.642.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:13:01AM +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-20 at 14:20 +1000, Paul Mackerras wrote:
> > Actually these days we do it by setting the decrementer (the built-in
> > timer facility) to generate an interrupt immediately (well, within one
> > timebase tick, i.e. a small number of nanoseconds).
> 
> Then that is something that wants curing I guess.. 

Curing?  Why?  How?

Paul.
