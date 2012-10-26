Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966063Ab2JZSlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:41:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60368 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966020Ab2JZSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:41:42 -0400
Message-ID: <508AD963.9090103@gmail.com>
Date: Fri, 26 Oct 2012 11:41:39 -0700
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>   <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>   <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>   <1351172849.12171.10.camel@twins>   <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>   <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>   <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>   <1351245264.16863.12.camel@twins>   <alpine.LFD.2.02.1210261208170.2756@ionos>   <1351248244.16863.13.camel@twins> <1351256204.16863.56.camel@twins>  <508AD291.1010803@gmail.com> <1351276134.8467.62.camel@gandalf.local.home>
In-Reply-To: <1351276134.8467.62.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 11:28 AM, Steven Rostedt wrote:
> On Fri, 2012-10-26 at 11:12 -0700, Juri Lelli wrote:
>
>> - scale down (right by 10) incoming parameters as to do internal
>>     math with ~1us resolution (and scale up outgoing params)
>
> Would scaling down by 9 be sufficient? That way the resolution is still
> just less than 1us.
>

I don't see any practical issue. Anyway, if, - as Thomas said - "It's
really pointless to even think about anything below microseconds
resolution", having an internal resolution just above a microsecond
sounds to me easier to justify to users. But I'm pretty open about
this :).

Thanks and Regards,

- Juri
