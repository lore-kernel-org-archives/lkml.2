Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0ETLHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:07:53 -0400
Received: from crca.org.au ([74.207.252.120]:41521 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0ETLHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:07:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BF517FE.1000103@tuxonice.net>
Date: Thu, 20 May 2010 21:07:42 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to push
 model
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
In-Reply-To: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I finally found the time to give this patch series a try. Minor updates 
were required, but I'm now running it against 2.6.34.

"Load balancing tick" is still number one in my powertop list of top 
causes of wakeups (sitting at ~60 to 80 per second as I type this, with 
~170 wakeups per second total). Comparing this to the numbers I posted 
earlier, we seem to have a win.

I do wonder, though, whether further work could still be done. If I take 
one core offline, for example, I'm still getting load balancing ticks. 
Intuitively, I'd expect there to be no need for them with only one core 
available. But maybe I'm just ignorant of what's going on.

Regards,

Nigel
