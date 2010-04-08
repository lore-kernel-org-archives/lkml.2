Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab0DHHE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:04:27 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:61853 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab0DHHEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:04:25 -0400
Message-ID: <4BBD7F18.1070205@oracle.com>
Date: Thu, 08 Apr 2010 00:00:40 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <20100331185916.GA12306@elte.hu> <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org> <4BB3DC4E.7030504@zytor.com> <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org> <4BB3DF46.8080008@zytor.com> <alpine.LRH.2.00.1004011200020.365@tundra.namei.org> <20100401125210.GA2445@elte.hu> <20100408063236.GA23489@elte.hu>
In-Reply-To: <20100408063236.GA23489@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBD7FAE.014F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 11:32 PM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * James Morris <jmorris@namei.org> wrote:
>>
>>> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
>>>
>>>> On 03/31/2010 04:43 PM, James Morris wrote:
>>>>>>
>>>>>> Upgraded how?  The problem no longer happens?
>>>>>
>>>>> Upgraded to the latest rawhide userland -- I have not since tested with 
>>>>> bootmem off.  I'll try and do so again when I get a chance.
>>>>>
>>>>
>>>> That would be great.  The sooner the better, obviously.
>>>
>>> I'm not seeing any problems now, with current Linus and rawhide.  I'll leave 
>>> bootmem off and see if anything comes up again.
>>
>> (a current bootlog would still be nice)
>>
>> Dave, can you reproduce any of these problems with Linus's latest?
> 
> ping? Can you or Dave reproduce the bug with -rc3 or later kernels? (If not 
> then it probably means that the bug you triggered was already fixed at the 
> time you reported it, as hpa suspected.)

James already reported -rc3 fix the problem for him.

Dave implied -rc3 fixed problem for him

Thanks

Yinghai
