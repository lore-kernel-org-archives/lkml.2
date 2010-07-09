Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0GIXCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:02:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48770 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0GIXCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:02:32 -0400
Message-ID: <4C37AA80.90203@zytor.com>
Date: Fri, 09 Jul 2010 16:02:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: werner@sys-linux.yi.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
References: <1278618295.14439@sys-linux.yi.org> <201007081622.04777.dmitry.torokhov@gmail.com>
In-Reply-To: <201007081622.04777.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 04:22 PM, Dmitry Torokhov wrote:
> On Thursday, July 08, 2010 12:44:55 pm werner@sys-linux.yi.org wrote:
>> For produce dmesg files, I rebooted with 2.6.26.2 , 2.6.35-rc4-git2 ,
>> 2.6.35-rc1 ; only the second case had the problem that the PS2 keyboard
>> and mouse dont work.
>>
>> Below the dmesg files.
>>
>> Added is also the config file for all 3 kernels, incl. 2.6.35-rc4-git2
>> (unchanged since -rc3-git1).  Its this whats now in /boot , so that it was
>> used during all these 3 boots (although the original configuration of the
>> two other kernels was different)
> 
> OK, here is your problem:
> 
>> CONFIG_X86_MRST=y
> 
> Disable it for now (you do not have Moorestown platfrom) and PS/2
> subsystem should be back.
> 

The recent patchset from Feng should take care of this, right?

	-hpa

