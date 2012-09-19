Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2ISL6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:58:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:44578 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2ISL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:57:58 -0400
Message-ID: <5059B324.70409@windriver.com>
Date: Wed, 19 Sep 2012 06:57:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <kgdb-bugreport@lists.sourceforge.net>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
References: <20120913150133.GA16238@lizard> <20120917113750.GA28838@kroah.com> <50571ADF.3000406@windriver.com> <20120917125427.GA23516@kroah.com> <20120917153943.GA7510@lizard> <20120917155408.GA302@kroah.com>
In-Reply-To: <20120917155408.GA302@kroah.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:54 AM, Greg Kroah-Hartman wrote:
> On Mon, Sep 17, 2012 at 08:39:43AM -0700, Anton Vorontsov wrote:
>> On Mon, Sep 17, 2012 at 05:54:27AM -0700, Greg Kroah-Hartman wrote:
>> [...]
>>>>> To make it easier, can I just take the tty driver patches now?  Will
>>>>> that break anything?
>>>> I have not made my way through the entire series yet, so I am not sure
>>>> if you need the kdb header changes or not, but so far it looks like
>>>> the tty pieces are separate.  If you add your ack Greg, I'll take the
>>>> whole series and merge it into kgdb-next, or after I finish the review
>>>> we could do it the other way around.
>>> Your tree is fine:
>>>
>>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> Let me know if you have problems merging this due to any tty patches,
>>> and if so, I'll be glad to take them through my tree.
>> Guys, thanks for taking a look into this!
>>
>> The patch that adds nmi console driver (i.e. tty/serial/kgdb_nmi.c)
>> depends on the first KDB patches in these series, and it depends on
>> amba-pl1011 and tty_port work, which is in tty-next.
>>
>> So, the series have to go via tty-next; I believe Jason won't able
>> to take it via his tree.
> Ok, I'll wait for Jason to review them.  Jason, let me know how it
> goes...
>

Other than 1, 2 and 7.   They all get:

Acked-by: Jason Wessel <jason.wessel@windriver.com>

I ran out of time to review things yesterday, but it is all reviewed now.   After we get some more comments from Anton, we can move forward.

Cheers,
Jason.
