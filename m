Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0KXAiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:38:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35894 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0KXAis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:38:48 -0500
Message-ID: <4CEC5E41.4020307@zytor.com>
Date: Tue, 23 Nov 2010 16:37:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
References: <cover.1290546539.git.jbaron@redhat.com>	 <4CEC33F6.9090808@zytor.com>	 <1290553914.30543.408.camel@gandalf.stny.rr.com>	 <4CEC4EF3.4000304@zytor.com>	 <1290557416.30543.420.camel@gandalf.stny.rr.com> <1290558991.30543.422.camel@gandalf.stny.rr.com>
In-Reply-To: <1290558991.30543.422.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 04:36 PM, Steven Rostedt wrote:
> On Tue, 2010-11-23 at 19:10 -0500, Steven Rostedt wrote:
> 
>> So you would rather have it as an if statement? Something like this:
>>
>> 	if (unlikely(JUMP_LABEL(key)))
>> 		__DO_TRACE(....);
>>
>> (Note, I like the above better too)
>>
> 
> I do like this better, but this change should wait till 2.6.38.
> 

Yes.

	-hpa
