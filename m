Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1BONcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:32:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1BONcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:32:52 -0500
Message-ID: <4D5A8021.2060001@zytor.com>
Date: Tue, 15 Feb 2011 05:31:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: Matt Fleming <matt@console-pimps.org>, David Miller <davem@davemloft.net>,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop>	<1297718964.23343.75.camel@gandalf.stny.rr.com>	<1297719576.23343.80.camel@gandalf.stny.rr.com>	<20110214.134600.179933733.davem@davemloft.net>	<20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>	<4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
In-Reply-To: <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 03:01 AM, Will Newton wrote:
> 
> The CPU in question has two sets of instructions:
> 
>   load/store - these go via the cache (write through)
>   ll/sc - these operate literally as if there is no cache (they do not
> hit on read or write)
> 
> This may or may not be a sensible way to architect a CPU, but I think
> it is possible to make it work. Making it work efficiently is more of
> a challenge.
> 

a) What "CPU in question" is this?
b) Why should we let this particular insane CPU slow ALL OTHER CPUs down?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

