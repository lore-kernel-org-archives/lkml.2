Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2KMPSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:18:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2KMPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:18:41 -0500
Message-ID: <50A264C6.4010906@redhat.com>
Date: Tue, 13 Nov 2012 10:18:30 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
References: <5077157A.7060401@redhat.com> <50772350.1070903@us.ibm.com> <20121011202103.GB2476@linux.vnet.ibm.com> <507839FC.3060204@redhat.com> <50A185D7.9080902@us.ibm.com>
In-Reply-To: <50A185D7.9080902@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2012 06:27 PM, John Stultz wrote:

> Hey Prarit,
>     Just back from being on leave, and wanted to check in on this. Did you ever
> get to run with an increase sample size to see how that affected things?  Its
> exactly your point that the non-NOHZ case could align the execution of a short
> run in a way that you always see good results, where as with NOHZ the alignment
> might not be the same, so you see periodic delays from timer interrupts, etc.
> 
> Anyway, let me know if this got resolved or not.

Hey John,

I never did narrow this down, although this "disappears" with the move to the
lower resolution patches in upstream.  I have not, however, done any testing to
see if the situation is actually resolved or if we just reduced the problem by a
factor of 1000 ;)

P.
