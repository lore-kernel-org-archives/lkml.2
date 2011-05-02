Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1EBScU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:32:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51819 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1EBScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:32:19 -0400
Message-ID: <4DBEF8A8.6040401@linux.vnet.ibm.com>
Date: Mon, 02 May 2011 11:32:08 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Carl Love <carll@us.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com> <20110429172525.GA2745@tassilo.jf.intel.com> <alpine.LFD.2.02.1104291938240.3005@ionos> <4DBC6BC1.5090102@linux.vnet.ibm.com> <20110501175505.GA27830@elte.hu>
In-Reply-To: <20110501175505.GA27830@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 10:55 AM, Ingo Molnar wrote:
> 
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
>> Carl Love and I recently completed some work to add perf_events support for 
>> the IBM Blue Waters machine's "CPU networking" chip, called the Torrent chip.  
>> We did all of this work based on a RHEL 6 kernel (2.6.32ish), which doesn't 
>> have Peter's more recent multi-PMU support.
>>
>> I would say that most if not all of the events are not generalizable in the 
>> sense that you are talking about; the events are very specific to the Torrent 
>> chip. [...]
> 
> That's ok and not a problem.
> 
> The issue here are events that *are* generalizable.
> 
>> So if I'm understanding what you have said correctly, we would not be able to 
>> get a forward port of this code committed without abstracting these events in 
>> a away that's acceptable to the kernel community. [...]
> 
> If the number of events worth generalizing is the empty set that's ok.
> 
> Thanks,
> 
> 	Ingo

Great, that's good to hear.

Thanks,

- Corey
