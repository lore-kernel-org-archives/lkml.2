Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1ESFdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:33:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:53581 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab1ESFdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:33:23 -0400
Subject: Re: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1305668416.2781.23.camel@pasglop>
Date: Thu, 19 May 2011 00:33:12 -0500
Cc: Richard Cochran <richardcochran@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7038D856-29A6-4D6C-A6DB-F4DB5256C6FA@kernel.crashing.org>
References: <20110517162827.GA16918@riccoc20.at.omicron.at> <1305668416.2781.23.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17, 2011, at 4:40 PM, Benjamin Herrenschmidt wrote:

> On Tue, 2011-05-17 at 18:28 +0200, Richard Cochran wrote:
>> Ben,
>> 
>> Recent 2.6.39-rc kernels behave strangely on the Freescale dual core
>> mpc8572 and p2020. There is a long pause (like 2 seconds) in the boot
>> sequence after "mpic: requesting IPIs..."
>> 
>> When the system comes up, only one core shows in /proc/cpuinfo. Later
>> on, lots of messages appear like the following:
>> 
>>   INFO: task ksoftirqd/1:9 blocked for more than 120 seconds.
>> 
>> I bisected [1] the problem to:
>> 
>>   commit c56e58537d504706954a06570b4034c04e5b7500
>>   Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>   Date:   Tue Mar 8 14:40:04 2011 +1100
>> 
>>       powerpc/smp: Create idle threads on demand and properly reset them
>> 
>> I don't see from that commit what had gone wrong. Perhaps you can
>> help resolve this?
> 
> Hrm, odd. Kumar, care to have a look ? That's what happens when you
> don't get me HW to test with :-)

I'm trying to work on it ;)

- k
