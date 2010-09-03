Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0ICIHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:07:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50924 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab0ICIHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:07:06 -0400
Date: Fri, 3 Sep 2010 11:06:42 +0300
From: Pauli Nieminen <ext-pauli.nieminen@nokia.com>
To: ext Peter Zijlstra <peterz@infradead.org>
Cc: ext Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pauli <suokkos@gmail.com>
Subject: Re: IPC between application and xserver is causing extra context
 switches
Message-ID: <20100903080642.GB19353@squeeze>
References: <20100809150211.GA29771@burn-it>
 <20100901025817.GA6200@Krystal>
 <20100903071738.GA19353@squeeze>
 <1283499074.1783.59.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283499074.1783.59.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Sep 2010 08:06:46.0235 (UTC) FILETIME=[F3E88AB0:01CB4B3E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 09:31 +0200, ext Peter Zijlstra wrote:
> On Fri, 2010-09-03 at 10:17 +0300, Pauli Nieminen wrote:
> > Scheduling at write is wrong because xserver doesn't know about client
> > priorities. 
> 
> Waking up the client at write is correct because you don't know if there
> is more to be written.
> 
> Really, your assumptions about when things schedule is wrong.
> 
>

Where is it wrong?

I'm just explaining what I have seen in trace output. I also try to explain
why it is wrong for xserver/client communication.

If problems that I see aren't scheduling problems then xserver has to
understand client priorities and duplicate scheduler code in user space.


