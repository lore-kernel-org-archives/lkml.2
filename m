Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0KXNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:49:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0KXNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:49:33 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=nTPQ0Fel6MqBzw-y_koA:9 a=MaLOIeltmZKCPuPbBxTsMVnC1koA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <1290602856.30543.465.camel@gandalf.stny.rr.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <1290548527.30543.401.camel@gandalf.stny.rr.com>
	 <20101123215604.GC4715@redhat.com>
	 <1290553854.30543.406.camel@gandalf.stny.rr.com>
	 <1290587362.2072.429.camel@laptop>
	 <1290602856.30543.465.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 08:49:29 -0500
Message-ID: <1290606569.30543.482.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 07:47 -0500, Steven Rostedt wrote:

> Again, its default off. Unless you specifically enable it, it does the
> old style tracepoints.

Thinking about this more, perhaps the best thing to do is just make the
jump label config depend on experimental.

-- Steve


