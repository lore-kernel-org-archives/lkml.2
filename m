Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab0KQP5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:57:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934749Ab0KQP5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:57:08 -0500
Message-ID: <4CE3FB0D.30902@redhat.com>
Date: Wed, 17 Nov 2010 17:55:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>	 <1290003110.2109.822.camel@laptop> <1290003505.2109.833.camel@laptop>	 <alpine.LFD.2.00.1011171529120.2900@localhost6.localdomain6> <1290008466.1921.21.camel@elnicho>
In-Reply-To: <1290008466.1921.21.camel@elnicho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:41 PM, Tom Zanussi wrote:
>
>> The only reason why these filters might make sense is to reduce the
>> trace volume on system wide traces in production environments, but
>> that's a completely different story. These scenarios can do with the
>> dynamic tracepoint stuff and the custom filtering w/o putting the
>> burden on the majority of users.
>>
> Yeah, in my mind, the main point of the filters was to be a 'blunt
> force' instrument preventing userspace from being overwhelmed by events.
> The real filtering would happen in userspace with e.g. real scripting
> languages.
>

Filtering is also useful for fine-grained perf events; this cannot be 
done in userspace.

