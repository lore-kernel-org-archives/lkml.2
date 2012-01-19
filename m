Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2ASO6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:58:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab2ASO6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:58:38 -0500
Message-ID: <4F182F81.2020200@zytor.com>
Date: Thu, 19 Jan 2012 06:58:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
References: <20120118195340.767928915@goodmis.org>  <20120118195926.797694014@goodmis.org> <20120119144141.GA547@Krystal> <1326984993.17534.125.camel@gandalf.stny.rr.com>
In-Reply-To: <1326984993.17534.125.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 06:56 AM, Steven Rostedt wrote:
>>
>> Is it possible that the compiler choose a jump that is not 2 or 5-byte ?
>> e.g. a jmp rel16 (e9 opcode) on 32-bit x86, or any of the other
>
> Isn't e9 the 5 byte opcode?
>

I think Mathieu is thinking of 66 e9 rel16 (66 e9 xx xx) which isn't 
used by the compiler since it truncates the result to 16 bits.

	-hpa
