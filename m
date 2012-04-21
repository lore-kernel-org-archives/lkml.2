Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2DUBz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:55:28 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:37040
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab2DUBz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:55:26 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzzz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F921375.8010708@am.sony.com>
Date: Fri, 20 Apr 2012 18:55:01 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rowand, Frank" <Frank_Rowand@sonyusa.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
References: <20120420122120.097464672@linutronix.de> <4F920788.3080405@am.sony.com>
In-Reply-To: <4F920788.3080405@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/12 18:04, Frank Rowand wrote:
> On 04/20/12 06:05, Thomas Gleixner wrote:
>> Dear all,
>>
>> I'm working on refactoring the SMP boot and CPU hotplug implementation.
> 
> Smoke test #1 successful.  Builds and boots on ARM Panda for:
> 
>   linux-3.4-rc3       CONFIG_PREEMPT_NONE
> 
>   linux-3.4-rc3-rt5   CONFIG_PREEMPT_RT_FULL


Further smoke testing successful.  Also builds and boots on ARM Realview for:

  linux-3.4-rc3      SMP, PREEMPT_NONE
  linux-3.4-rc3-rt5  SMP, PREEMPT_RT_FULL

  linux-3.4-rc3-rt5  UP,  PREEMPT_RT_FULL


-Frank



