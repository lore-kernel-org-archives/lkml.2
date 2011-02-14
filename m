Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1BNWdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:33:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59389
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab1BNWdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:33:00 -0500
Date: Mon, 14 Feb 2011 14:33:36 -0800 (PST)
Message-Id: <20110214.143336.226766324.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: hpa@zytor.com, rostedt@goodmis.org, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <BLU0-SMTP98BFCC52FD41661DD9CC1E96D00@phx.gbl>
References: <1297722030.23343.86.camel@gandalf.stny.rr.com>
	<4D59AAFC.7010503@zytor.com>
	<BLU0-SMTP98BFCC52FD41661DD9CC1E96D00@phx.gbl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 14 Feb 2011 17:29:58 -0500

> * H. Peter Anvin (hpa@zytor.com) wrote:
>> On 02/14/2011 02:20 PM, Steven Rostedt wrote:
>> > 
>> > Ideally, we would like a single atomic_read() but due to these wacky
>> > archs, it may not be possible.
>> > 
>> 
>> #ifdef ARCH_ATOMIC_READ_SUCKS_EGGS?
>> 
>> 	-hpa
> 
> lol :)
> 
> Hrm, I wonder if it might cause problems with combinations of "cmpxchg"
> and "read" performed on a variable (without using atomic.h).

We do that everywhere, it has to work.
