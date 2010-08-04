Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0HDEiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:38:16 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:40912 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0HDEiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:38:15 -0400
X-Greylist: delayed 2687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 00:38:15 EDT
Message-ID: <4C58E42B.40000@cs.unc.edu>
Date: Tue, 03 Aug 2010 23:53:15 -0400
From: Andrea Bastoni <bastoni@cs.unc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: periods and deadlines in SCHED_DEADLINE
References: <1278682707.6083.227.camel@Palantir>	 <1278685133.1900.201.camel@laptop>	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>	 <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>	 <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu> <1280828775.1923.447.camel@laptop>
In-Reply-To: <1280828775.1923.447.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 05:46 AM, Peter Zijlstra wrote:
> On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
>> If you want to do G-EDF with limited and different budgets on each CPU
>> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
>> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
>> restricted-supply scheduling, which is significantly more complicated
>> to analyze (see [1,2]).
> 
> Would making the thing homogenious by assuming the worst for all cpus
> make the analysis easier? That is, in the above example, only allow the
> G-EDF scheduler to run for 100 out of 1000 ms on both cpus.

Both [1,2] (and also [4]) assumes a more general model than the one based on the worst for all
CPUs, therefore the analysis (based on these papers) will likely be more pessimistic, but not
necessarily easier.

- Andrea

[4] E. Bini, M. Bertogna, S. Baruah, Virtual Multiprocessor Platforms: Specification and Use. In
Proceedings of the 2009 30th IEEE Real-Time Systems Symposium, 437-446, 2009.

-- 
Andrea Bastoni
Visiting Ph.D. Student
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.sprg.uniroma2.it/home/bastoni/
