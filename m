Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1BNWVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:21:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1BNWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:21:33 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=nVx1mdKs5a3Z6u8WvUIA:9 a=V70QSrZ0llxLQDB1r6JL3uxOpWgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <1297722030.23343.86.camel@gandalf.stny.rr.com>
References: <1297707868.5226.189.camel@laptop>
	 <1297718964.23343.75.camel@gandalf.stny.rr.com>
	 <1297719576.23343.80.camel@gandalf.stny.rr.com>
	 <20110214.134600.179933733.davem@davemloft.net>
	 <1297722030.23343.86.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 17:21:30 -0500
Message-ID: <1297722090.23343.87.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 17:20 -0500, Steven Rostedt wrote:

> I guess the issue is, if you use ll/sc on memory, you must always use
> ll/sc on that memory, otherwise any normal read won't read the proper
> cache.

s/cache/memory/

-- Steve


