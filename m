Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1LCRhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:37:52 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54216 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1LCRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:37:50 -0500
Message-ID: <4EDA5E5A.4050804@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 23:07:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: 3.2.0-rc4+ (Linus GIT af968e29acd91ebeb4224e899202c46c93171ecd)
 -- Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze,
 wq_busy=0):
References: <CAHFgRy_ae70MZOgY8q3i36NJh42=GK=XP=EA=ktxgXiFzjY49w@mail.gmail.com> <4ED9C7D7.5030300@linux.vnet.ibm.com> <CAHFgRy_o6b9ih=BXysL9Ws6KDcVcOkJ2hnLa9zZJ=m-=zoLmPA@mail.gmail.com> <4EDA51FF.8050904@linux.vnet.ibm.com> <CAHFgRy_H4-aN7X65ivfgVS1iinw58kSR6Hbg2A6kGAxTOrWApg@mail.gmail.com>
In-Reply-To: <CAHFgRy_H4-aN7X65ivfgVS1iinw58kSR6Hbg2A6kGAxTOrWApg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120307-7014-0000-0000-00000033AE31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 10:47 PM, Miles Lane wrote:

> On Sat, Dec 3, 2011 at 11:44 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 12/03/2011 09:07 PM, Miles Lane wrote:
>>
>>> Thanks!  The patch worked perfectly.
>>>
>>>         Miles
>>>
>>
>>
>> I had written that patch when I found a possibility of freezing failure when
>> looking at the code. I hadn't really hit the problem myself. (And to test my
>> patch's effectiveness, I had used a synthetic scenario that I had created.)
>>
>> So, since you seem to have hit the problem during normal usage itself and not
>> while doing anything fancy, out of curiosity, what triggered the problem?
> 
> I was intentionally checking for problems with reading the contents of
> the /sys and /proc trees.  So I ran:
> find /sys -name "[a-z]*" | xargs head
> and
> find /proc -name "[q-z]*" | xargs head
> and then, while the commands were processing files I suspended
> (unsuccessfully) the laptop.
> 
> I have often found bugs in this area, so I periodically run this test.
>  Sometimes it turns up problems in accessing specific information in
> the data files.  This is the first time I added trying to suspend
> while the test was running.
> 
> Happy coding!
>       Miles
> 


Great! Thanks for telling how you triggered the problem!

Regards,
Srivatsa S. Bhat

