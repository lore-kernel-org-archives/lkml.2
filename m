Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1ECVdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:33:05 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:56283 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1ECVdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:33:04 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 17:33:04 EDT
Message-ID: <4DC07329.30906@docs.homelinux.org>
Date: Tue, 03 May 2011 23:27:05 +0200
From: Juan Dos Santos <jdossantos@docs.homelinux.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hank Janssen <hjanssen@microsoft.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Error in Hyper-V modules hv_vmbus
References: <4DBC1F2F.5050205@docs.homelinux.org> <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com> <4DBD53F6.6070603@docs.homelinux.org> <6E21E5352C11B742B20C142EB499E0481DF83C@TK5EX14MBXC124.redmond.corp.microsoft.com> <bbdd3ea71462ef4f7d152a67e52cafb1@docs.homelinux.org> <6E21E5352C11B742B20C142EB499E0481DF899@TK5EX14MBXC124.redmond.corp.microsoft.com> <8AFC7968D54FB448A30D8F38F259C562498A27AF@TK5EX14MBXC114.redmond.corp.microsoft.com>
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C562498A27AF@TK5EX14MBXC114.redmond.corp.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> -----Original Message-----
>>>> From: root@docs.homelinux.org [mailto:root@docs.homelinux.org]
>>>> Sent: Tuesday, May 03, 2011 10:52 AM
>>>> To: KY Srinivasan
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Subject: RE: Error in Hyper-V modules hv_vmbus
>>>>
>>>>   On Tue, 3 May 2011 13:42:43 +0000, KY Srinivasan wrote:
>>>>>> -----Original Message-----
>>>>>> From: root [mailto:root@docs.homelinux.org]
>>>>>> Sent: Sunday, May 01, 2011 8:37 AM
>>>>>> To: KY Srinivasan
>>>>>> Cc: linux-kernel@vger.kernel.org
>>>>>> Subject: Re: Error in Hyper-V modules hv_vmbus
>>>>>>
>>>>>> Windows Server Core 2008 R2 with SP2
>>>>> This is a known problem and a fix has been submitted - the patch
>>>>> is yet to be applied though. Once the hv patches that are in the
>>>>> queue are applied, this problem will be fixed. In the interim, if
>>>>> you want an immediate fix, I could send you the patch that will
>>>>> apply against the tree you have.
>>>>>
>>>>> Regards,
>>>>>
>>>>> K. Y
>>>>>> Regards
>>>>>> Juan Dos Santos
>>>>   Could You send me the patch? So I can test it, I am using the
>>>> kernel source from
>>>> http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc5
>>>> .t ar.bz2,  is the patch compatible with this kernel source?
>>> This is a very old version of the hyper-V driver code compared to what
>>> is in Greg's tree and looking at the code It does not look like the
>>> problem you are seeing is the problem my patch fixes. We will do some
>>> additional testing and get back to you. It would be very useful if you
>>> can post the dmesg or stack trace that can shed additional light on the
>> problem.
> Juan,
>
> I just fixed a few issues in Ubuntu 10.10 that might be similar.
>
> I will spin up a debian system and see if I can reproduce the problem and
> submit a patch To fix it.
>
> Hank.
Hi Hank

Ok thanks, tomorrow I will post dmesg and more debuging stuff about this 
problem...

Regards
Juan Dos Santos
