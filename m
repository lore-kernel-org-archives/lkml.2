Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1GZX6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:58:04 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:33378 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064Ab1GZX6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:58:02 -0400
Message-ID: <4E2F5486.1080007@localhost>
Date: Tue, 26 Jul 2011 16:57:58 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <4E2DF459.3030509@localhost> <20110726091310.GP16561@pengutronix.de> <4E2F5344.3030103@localhost>
In-Reply-To: <4E2F5344.3030103@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 04:52 PM, Fernando Lopez-Lezcano wrote:
> On 07/26/2011 02:13 AM, Uwe Kleine-König wrote:
>> On Mon, Jul 25, 2011 at 03:55:21PM -0700, Fernando Lopez-Lezcano wrote:
>>> On 07/24/2011 03:33 AM, Thomas Gleixner wrote:
>>>> Dear RT Folks,
>>>>
>>>> I'm pleased to announce the 3.0-rt3 release.
>>>
>>> Thanks!!... testing on a dual core laptop, fedora 15, 32 bit:
>>>
>>> [ 32.169727] BUG: MAX_LOCKDEP_ENTRIES too low!
>>> [ 32.169730] turning off the locking correctness validator.
>>>
>>> (where do I change this?)
>> I'd guess you need to increase MAX_LOCKDEP_ENTRIES which is defined in
>> kernel/lockdep_internals.h.
>>
>> BTW, I hit that, too.
>
> Thanks, I upped that to 32768 (16384) but on boot I got another
> complaint about MAX_LOCKDEP_CHAINS so I changed MAX_LOCKDEP_CHAIN_BITS
> from 15 to 31 and, well, the kernel build complains about "size of array
> 'local_chains' is too large" (chain_hlocks as well) and does not build...
>
> Oh well...

(I meant to myself - of COURSE, _think_ before changing things and 
meditate about the implications of power mathematical operations).

:-)
-- Fernando
