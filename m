Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2GRRiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:38:05 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58126 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2GRRiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:38:03 -0400
Message-ID: <5006F434.9010707@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 23:06:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
References: <20120716103749.122800930@linutronix.de> <20120716152224.GF2403@linux.vnet.ibm.com>
In-Reply-To: <20120716152224.GF2403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071817-2674-0000-0000-0000054BE71D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 08:52 PM, Paul E. McKenney wrote:
> On Mon, Jul 16, 2012 at 10:42:34AM -0000, Thomas Gleixner wrote:
>> The following series implements the infrastructure for parking and
>> unparking kernel threads to avoid the full teardown and fork on cpu
>> hotplug operations along with management infrastructure for hotplug
>> and users.
>>
>> Changes vs. V2:
>>
>>  Use callbacks for all functionality. Thanks to Rusty for pointing
>>  that out. It makes the use sites nice and simple and keeps all the
>>  code which would be duplicated otherwise on the core.
> 
> Hello, Thomas,
> 
> What version should I apply this patchset to?  I tried v3.5-rc7, but
> got lots of warnings (one shown below) and the watchdog patch did not
> apply.
> 

Hi Paul,

This patchset applies cleanly on Thomas' smp/hotplug branch in the -tip
tree.

Regards,
Srivatsa S. Bhat

