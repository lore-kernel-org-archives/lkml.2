Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1BNWXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:23:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51346 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1BNWXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:23:16 -0500
Message-ID: <4D59AAFC.7010503@zytor.com>
Date: Mon, 14 Feb 2011 14:21:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Miller <davem@davemloft.net>, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop>	 <1297718964.23343.75.camel@gandalf.stny.rr.com>	 <1297719576.23343.80.camel@gandalf.stny.rr.com>	 <20110214.134600.179933733.davem@davemloft.net> <1297722030.23343.86.camel@gandalf.stny.rr.com>
In-Reply-To: <1297722030.23343.86.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 02:20 PM, Steven Rostedt wrote:
> 
> Ideally, we would like a single atomic_read() but due to these wacky
> archs, it may not be possible.
> 

#ifdef ARCH_ATOMIC_READ_SUCKS_EGGS?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

