Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0KXAgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:36:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0KXAge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:36:34 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=fw9oxepunfSf3KicNw0A:9 a=n793RStf4hkp7UPiXo3XyxH9QPMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290557416.30543.420.camel@gandalf.stny.rr.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <4CEC33F6.9090808@zytor.com>
	 <1290553914.30543.408.camel@gandalf.stny.rr.com>
	 <4CEC4EF3.4000304@zytor.com>
	 <1290557416.30543.420.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 19:36:31 -0500
Message-ID: <1290558991.30543.422.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 19:10 -0500, Steven Rostedt wrote:

> So you would rather have it as an if statement? Something like this:
> 
> 	if (unlikely(JUMP_LABEL(key)))
> 		__DO_TRACE(....);
> 
> (Note, I like the above better too)
> 

I do like this better, but this change should wait till 2.6.38.

-- Steve


