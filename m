Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2ATKGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 05:06:18 -0500
Received: from host86-180-251-195.range86-180.btcentralplus.com ([86.180.251.195]:43983
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2ATKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 05:06:14 -0500
Message-ID: <4F193C8D.3010506@oak.selfip.net>
Date: Fri, 20 Jan 2012 10:06:05 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120111 Thunderbird/10.0
MIME-Version: 1.0
To: "hpanvin@gmail.com" <hpa@zytor.com>
CC: Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Postgres fails to start due to kernel issue?
References: <4F18B911.2060601@oak.selfip.net> <CA+5PVA5U-mJKMR63=1Tc6arjhtTkFNOjvSumFiENdJRyVs1Epg@mail.gmail.com> <534a6e5c-4c14-48bd-a9dc-d5b884daeb63@email.android.com>
In-Reply-To: <534a6e5c-4c14-48bd-a9dc-d5b884daeb63@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2012 03:13, hpanvin@gmail.com wrote:
> Yes, it almost certainly is.  Fixed in rc1.

Correct, working again under 3.3.0-rc1.  Thanks!

Linux s1 3.3.0-rc1 #135 SMP Fri Jan 20 09:59:56 GMT 2012 i686 
Pentium III (Coppermine) GenuineIntel GNU/Linux

>
> Josh Boyer<jwboyer@gmail.com>  wrote:
>
>> On Thu, Jan 19, 2012 at 7:45 PM, Dave Haywood<tla@oak.selfip.net>
>> wrote:
>>> Hi,
>>>
>>>   I noticed after upgrading to 3.2.0-08812-gc2bc3a3 that Postgres-9.1
>> server
>>> fails to start with error:
>>>
>>> FATAL:  could not create shared memory segment: Function not
>> implemented
>>> DETAIL:  Failed system call was shmget(key=5432001, size=30523392,
>> 03600).
>>>   After some googling, I thought it was a SYSV shared memory sizing
>> issue but
>>> manually changing kernel.shmmax and kernel.shmall had no effect.
>>>
>>>   The problem has been introduced between 3.2.0-08694-g53999bf and
>>> 3.2.0-08812-gc2bc3a3.
>>>
>>>   Let me know if you need any more information.  Bisecting is *very*
>> slow on
>>> this machine!
>> If you run strace on it, does it fail with ENOSYS?  This might be
>> related to an issue Peter just fixed.
>>
>> josh

