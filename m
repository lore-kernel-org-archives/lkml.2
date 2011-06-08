Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1FHTtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:49:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52893 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1FHTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:49:46 -0400
Message-ID: <4DEFD220.5040507@kernel.org>
Date: Wed, 08 Jun 2011 12:48:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <4DEE17F9.6020503@gmail.com> <4DEEA548.5020405@kernel.org> <4DEFA6E3.6090809@xs4all.nl> <4DEFCAE0.6050700@kernel.org> <20110608192321.GA28865@srcf.ucam.org> <4DEFCD07.5020505@kernel.org> <20110608192950.GA29235@srcf.ucam.org> <4DEFCF1A.9030400@kernel.org> <20110608193833.GA29855@srcf.ucam.org>
In-Reply-To: <20110608193833.GA29855@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DEFD22A.0120,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 12:38 PM, Matthew Garrett wrote:
> On Wed, Jun 08, 2011 at 12:35:54PM -0700, Yinghai Lu wrote:
>> On 06/08/2011 12:29 PM, Matthew Garrett wrote:
>>>> what former? you can not fix some corner case by breaking most other cases.
>>>
>>> All Dell laptops, all new Apples, some Lenovos, various Intel server 
>>> platforms. That I've found so far.
>>
>> do you mean before that patch, all those machine will not boot linux kernel with UEFI support?
> 
> Correct.

with or without EFI runtime services?

Yinghai
