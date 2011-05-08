Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1EHV4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:56:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:61430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1EHV4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:56:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="744170824"
Message-ID: <4DC71171.9090408@linux.intel.com>
Date: Sun, 08 May 2011 14:56:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
References: <4DC45537.6070609@linux.intel.com> <1304713252.25414.2532.camel@gandalf.stny.rr.com> <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com> <20110507065803.GA23414@elte.hu> <1304765110.25414.2564.camel@gandalf.stny.rr.com> <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo> <4DC58888.9030402@linux.intel.com> <20110508210815.GA2014@nowhere>
In-Reply-To: <20110508210815.GA2014@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5
>> btw if you remove some of these, how is userland supposed to find
>> out if an event happened in irq context?
> You can use the irq events for that.

so I have to follow 2 "thousands of timers per second" events just to 
find out if my "once a week" event happened in interrupt context?
I assume you are making a joke with your answer....

