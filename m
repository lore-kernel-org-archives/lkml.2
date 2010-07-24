Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0GXJU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:20:28 -0400
Received: from postin.uv.es ([147.156.1.90]:49389 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab0GXJU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:20:27 -0400
Message-ID: <4C4AB036.3060003@postal.uv.es>
Date: Sat, 24 Jul 2010 11:19:50 +0200
From: Enrico Bandiello <enban@postal.uv.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Enrico Bandiello <enban@alumni.uv.es>
Subject: Re: [Bug #16307] i915 in kernel 2.6.35-rc3, high number of wakeups
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>	<tneGvaw1wLL.A.mXB.p3XSMB@chimera> <20100723102532.6bfade32@virtuousgeek.org>
In-Reply-To: <20100723102532.6bfade32@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Userflux: Whitelisted rcpt enban@alumni.uv.es. User email not accounted
X-RelayDelay-Mem: Whitelisted relay grajo.ci.uv.es [147.156.0.253]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 07:25 PM, Jesse Barnes wrote:
> On Fri, 23 Jul 2010 13:47:31 +0200 (CEST)
> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16307
>> Subject		: i915 in kernel 2.6.35-rc3, high number of wakeups
>> Submitter	: Enrico Bandiello<enban@postal.uv.es>
>> Date		: 2010-06-26 16:57 (28 days old)
>> Message-ID	:<4C26317A.5070309@postal.uv.es>
>> References	: http://marc.info/?l=linux-kernel&m=127757403404259&w=2
>
> Just updated the bug for this one.  Enrico, you say this behavior is
> recent.  Can you bisect between 2.6.34 and when the problem started?
>
Hi. I just tried, but can't find anything useful until now (surely it's 
my fault: it was my first attempt at bisection). Please let me try again 
in the next days.
