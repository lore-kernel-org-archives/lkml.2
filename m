Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1BQBGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:06:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1BQBGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:06:01 -0500
Message-ID: <4D5C7418.4080307@zytor.com>
Date: Wed, 16 Feb 2011 17:04:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, simoneau@ele.uri.edu,
        will.newton@gmail.com, matt@console-pimps.org, rostedt@goodmis.org,
        peterz@infradead.org, jbaron@redhat.com, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <1297808418.2460.9.camel@pasglop> <20110216083542.GE16529@elte.hu>
In-Reply-To: <20110216083542.GE16529@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 12:35 AM, Ingo Molnar wrote:
> 
> Just curious: how does this work if there's an interrupt (or NMI) right after the 
> invalidate instruction but before the 'll' instruction? The IRQ/NMI may refill the 
> L1. Or are the two instructions coupled by hw (they form a single instruction in 
> essence) and irqs/NMIs are inhibited inbetween?
> 

http://en.wikipedia.org/wiki/Load-link/store-conditional

	-hpa
