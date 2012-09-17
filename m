Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2IQMoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:44:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:48945 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2IQMoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:44:17 -0400
Message-ID: <50571ADF.3000406@windriver.com>
Date: Mon, 17 Sep 2012 07:43:11 -0500
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
References: <20120913150133.GA16238@lizard> <20120917113750.GA28838@kroah.com>
In-Reply-To: <20120917113750.GA28838@kroah.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 06:37 AM, Greg Kroah-Hartman wrote:
> On Thu, Sep 13, 2012 at 08:01:33AM -0700, Anton Vorontsov wrote:
>> Hi all,
>>
>> Here comes the lucky v7:
>>
>> - Per Alan Cox's suggestion added hangup method and removed a small
>>   leftover;
>> - Per Colin Cross' suggestion moved IRQ quiescing logic into
>>   poll_get_char routine. IIUC, Alan is less unhappy about it.  As a
>>   result, clear_irq() callback dropped.
>>
>> These patches can be found in the following repo (based on tty-next):
>>
>> 	git://git.infradead.org/users/cbou/linux-nmi-kdb.git master
>>
>> Old changelogs and rationale for these patches can be found here:
>>
>> 	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
>> 	v6: http://lkml.org/lkml/2012/9/10/2
> I have no objection to these patches, and as they are based on my
> tty-next tree, should I be the ones accepting them?  If so, then I need
> a bunch of acks from others involved in the kdb/kgdb code before I can
> do so.
>
> To make it easier, can I just take the tty driver patches now?  Will
> that break anything?

I have not made my way through the entire series yet, so I am not sure if you need the kdb header changes or not, but so far it looks like the tty pieces are separate.  If you add your ack Greg, I'll take the whole series and merge it into kgdb-next, or after I finish the review we could do it the other way around.

Cheers,
Jason.
