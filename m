Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2DUXjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 19:39:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54803 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2DUXj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 19:39:28 -0400
Message-ID: <4F93452B.6020506@garzik.org>
Date: Sat, 21 Apr 2012 19:39:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
CC: Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        jack_wang <jack_wang@usish.com>
Subject: Re: [GIT PULL] libsas fixes for 3.4-rc4
References: <1334960945.21447.19.camel@ultramagnus.opencreations.com> <1335011336.3081.12.camel@dabdike.lan> <CABE8wwvQ5_4DnOOce8PVcuR=k0RpzcXN5qbNhQ-=+Cq+Zqv6Dg@mail.gmail.com>
In-Reply-To: <CABE8wwvQ5_4DnOOce8PVcuR=k0RpzcXN5qbNhQ-=+Cq+Zqv6Dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 03:57 PM, Dan Williams wrote:
> On Sat, Apr 21, 2012 at 5:28 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com>  wrote:
>> On Fri, 2012-04-20 at 15:29 -0700, Dan Williams wrote:
>>> These patches, save for the new "scsi: fix eh wakeup (scsi_schedule_eh
>>> vs scsi_restart_operations)" and "Revert "[SCSI] libsas: fix sas port
>>> naming", were all originally posted before the merge
>>> window opened, and have also appeared in -next for the same timeframe.
>>>
>>> The commit dates are not that aged (9 days old) because they were
>>> rebased out of larger set of updates that were pending for 3.4.
>>>
>>> There is a mix of pure regression fixes and fixes for long-standing bugs
>>> in libsas.  Some of the long-standing bug fixes are made worse / easier
>>> to trigger by the new async error handling scheme.
>>>
>>> The largest patch in the series is "libata, libsas: introduce sched_eh
>>> and end_eh port ops" it has been on the list since March 10th.
>>>
>>> Jack Wang has independently tested this set with pm8001 and reports
>>> success. [1]
>>>
>>> Apologies if scsi-rc-fixes was in the process of picking these up.  With
>>> -rc4 looming I lost my nerve and pulled the trigger.
>>
>> Right, so as a point of process, these are SCSI fixes and are supposed
>> to be going through the SCSI tree.  The only urgent one is the revert; I
>> still have outstanding questions about some of the others.
>
> Up until this feedback I thought the branch was going to be pulled
> intact.  So, not trying to subvert process, just thought this request
> would be seen as helpful since you seem to have been rather busy of
> late.  Yes, I'd much rather these go through the SCSI tree.

[thread semi-hijacking]

Busy-ness++  :/   I'm a bit disappointed that these one-liner bug fixes 
for SCSI have not been applied, despite repeated pings:

	http://www.spinics.net/lists/linux-scsi/msg58712.html

Over a month has passed with zero comments (or objections), and we've 
now missed -rc4.

Unless I hear soon, I'll throw them into libata-dev (thus, linux-next) 
and kick them upstairs.

James has been replying to other stuff on the lists, so I'm not really 
sure how these basic, one-liner fixes keep slipping by.

	Jeff


