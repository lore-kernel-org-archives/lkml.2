Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2COE0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:26:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47076 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2COE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:26:18 -0400
Message-ID: <4F616EA6.5030402@gmail.com>
Date: Thu, 15 Mar 2012 04:23:02 +0000
From: Vasco Dias <rafa.vasco@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: =?UTF-8?B?TW90aWVqdXMgSmFrxaF0eXM=?= <desired.mta@gmail.com>
CC: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        mikew@google.com
Subject: Re: Problem with efibootmgr on asus 1215b
References: <20120312143806.GB12382@srcf.ucam.org> <20120315012941.GA24251@pierce> <4F61537C.8030309@gmail.com> <20120315030631.GA28296@pierce>
In-Reply-To: <20120315030631.GA28296@pierce>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15 Mar 2012 03:06:33 AM WET, Motiejus Jakštys wrote:
> On Thu, Mar 15, 2012 at 02:27:08AM +0000, Vasco Dias wrote:
>> On Thu 15 Mar 2012 01:29:41 AM WET, Motiejus Jakštys wrote:
>>>> Somewhat late to this I know, but:
>>>>
>>>> On Fri, Jan 20, 2012 at 11:48:26AM +0000, Matt Fleming wrote:
>>>
>>> Just to let you know I apparently have exactly the same issue with the same
>>> laptop. If it can help, I could try installing the M$ Student Edition during
>>> the weekend and report the results.
>>>
>>> Windows Server 2008 64-bit, fresh GPT partition table will be my lab
>>> environment. Standard installation procedure.
>>>
>>> I am running Ubuntu 12.04 with 3.2.0-18-generic.
>>>
>>> Motiejus
>>
>> I have to say that before installing linux i tried installing
>> windows right after
>> converting the system to gpt and after selecting the partition to
>> install it it
>> would just BSOD.
>>
>> I downloaded windows from my msdna account, converted it to boot
>> from the usb drive and manually selected the efi file from the drive
>> to launch
>> the windows setup.
>>
>> Sometimes it would reboot just after starting, other times it would BSOD
>> after selecting the partition and clicking next and yet other times
>> it would
>> start installing and then BSOD.
>>
>> After at least 20 different attemps there was just one time that
>> before going into BSOD that it successfuly registered the microsoft
>> boot program with the efi boot variables.
>>
>> All that assuming the files on the usb drive were not corrupted ;)
>> (it would be fun if they were)
>
> Thanks for response, now I know what to expect. Sounds like an *alternative*
> way to spend a weekend.
>
> Which version exactly did you use?
>
> In any case, I will verify your findings.
>
> So AFAIK there is no way to boot 64 bit linux (or even as of now - windows)
> without entering the UEFI shell and manually starting the UEFI loader (like
> [1])?
>
> [1]: https://bbs.archlinux.org/viewtopic.php?pid=1064647#p1064647
>
> Motiejus

The version i used was "Microsoft Windows 7 Professional with Service 
Pack 1 64-bit (English)"
and to put it to boot from the usb drive i read somewhere how to do it.

I would be happy actually if you were able to do it, it could mean 
something very wrong on my side,
if not it really means this laptop needs the firmware fixed from asus.

For your question, at least I have to do it that way.
