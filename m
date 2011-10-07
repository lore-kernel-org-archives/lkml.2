Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab1JGXFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:05:46 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:44747 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754769Ab1JGXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:05:45 -0400
Message-ID: <4E8F85C6.6010309@ccrma.stanford.edu>
Date: Fri, 07 Oct 2011 16:05:42 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0.6-rt17
References: <alpine.LFD.2.02.1110070046270.3240@ionos> <4E8F3605.6060104@localhost> <4E8F58ED.9060702@localhost> <alpine.LFD.2.02.1110080000400.3240@ionos>
In-Reply-To: <alpine.LFD.2.02.1110080000400.3240@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 03:02 PM, Thomas Gleixner wrote:
> On Fri, 7 Oct 2011, Fernando Lopez-Lezcano wrote:
>> On 10/07/2011 10:25 AM, Fernando Lopez-Lezcano wrote:
>>> On 10/06/2011 06:15 PM, Thomas Gleixner wrote:
>>>> I'm pleased to announce the 3.0.6-rt17 release.
>>>
>>> Hi and thanks again. So far this one is not hanging which is very good
>>> news. But I still see the hrtimer_fixup_activate warnings I reported for
>>> rt16...
>>
>> I tried rt17 on my workstation and it froze after a few minutes (quad core
>> intel based desktop). Reset button freeze. Then I set up my serial console and
>> tried it out. I could not get it to freeze permanently but I got _many_
>> hrtimer_fixup_activate warnings and while the console is sending those the
>> gnome interface freezes (this is on fc14). So it is not very usable for
>> debugging...
>>
>> Just tried again after another reboot (@ 115200 baud) and it worked for a
>> while. Then it started spewing messages again and it is again unusable. I'm
>> attaching a trace of what was sent to the serial console while the machine
>> froze temporarily.
>
> Does adding nohz=off to the kernel commandline solve it?
>
> You probably posted your .config before, but could you please send it
> again (private mail is fine).

(config sent privately)

"nohz=off" makes the warnings disappear! It appears to work normally but 
it has not been long :-)

-- Fernando
