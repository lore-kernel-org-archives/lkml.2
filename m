Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1ECOvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:51:48 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:34328 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1ECOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:51:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 03 May 2011 16:51:44 +0200
From: root@docs.homelinux.org
To: KY Srinivasan <kys@microsoft.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules =?UTF-8?Q?hv=5Fvmbus?=
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DF83C@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <4DBC1F2F.5050205@docs.homelinux.org>
 <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <4DBD53F6.6070603@docs.homelinux.org>
 <6E21E5352C11B742B20C142EB499E0481DF83C@TK5EX14MBXC124.redmond.corp.microsoft.com>
Message-ID: <bbdd3ea71462ef4f7d152a67e52cafb1@docs.homelinux.org>
User-Agent: Roundcube Webmail/0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Tue, 3 May 2011 13:42:43 +0000, KY Srinivasan wrote:
>> -----Original Message-----
>> From: root [mailto:root@docs.homelinux.org]
>> Sent: Sunday, May 01, 2011 8:37 AM
>> To: KY Srinivasan
>> Cc: linux-kernel@vger.kernel.org
>> Subject: Re: Error in Hyper-V modules hv_vmbus
>>
>>
>> >
>> >> -----Original Message-----
>> >> From: root [mailto:root@docs.homelinux.org]
>> >> Sent: Saturday, April 30, 2011 10:40 AM
>> >> To: linux-kernel@vger.kernel.org; KY Srinivasan
>> >> Subject: Error in Hyper-V modules hv_vmbus
>> >>
>> >> Hello
>> >>
>> >> I have compiled and installed the new 2.6.39-rc5 linux kernel 
>> with
>> >> Microsoft Hyper-V modules enabled on my Debian Squeeze system. 
>> After a
>> >> reboot I get these errors (sorry can post only screenshots 
>> because I
>> >> can't copy the log):
>> > What is the version of the Windows host. I have seen some issues 
>> with
>> > older hosts, where the vmbus driver does not get the correct irq. 
>> I have
>> > submitted a patch for this (this is yet to be applied by Greg).
>> >
>> > Regards,
>> >
>> > K. Y
>> >
>>
>> Windows Server Core 2008 R2 with SP2
>
> This is a known problem and a fix has been submitted - the patch is
> yet to be applied
> though. Once the hv patches that are in the queue are applied, this 
> problem
> will be fixed. In the interim, if you want an immediate fix, I could
> send you the patch
> that will apply against the tree you have.
>
> Regards,
>
> K. Y
>>
>> Regards
>> Juan Dos Santos

 Could You send me the patch? So I can test it, I am using the kernel 
 source from 
 http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc5.tar.bz2, 
 is the patch compatible with this kernel source?

 Regards
 Juan Dos Santos

