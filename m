Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1FHT2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:28:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41824 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1FHT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:28:05 -0400
Message-ID: <4DEFCD07.5020505@kernel.org>
Date: Wed, 08 Jun 2011 12:27:03 -0700
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
References: <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <4DEE17F9.6020503@gmail.com> <4DEEA548.5020405@kernel.org> <4DEFA6E3.6090809@xs4all.nl> <4DEFCAE0.6050700@kernel.org> <20110608192321.GA28865@srcf.ucam.org>
In-Reply-To: <20110608192321.GA28865@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DEFCD11.00A0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 12:23 PM, Matthew Garrett wrote:
> On Wed, Jun 08, 2011 at 12:17:52PM -0700, Yinghai Lu wrote:
>> we need to revert patch from mjg.
>>
>> From 916f676f8dc016103f983c7ec54c18ecdbb6e349 Mon Sep 17 00:00:00 2001
>> From: Matthew Garrett <mjg@redhat.com>
>> Date: Wed, 25 May 2011 09:53:13 -0400
>> Subject: [PATCH] x86, efi: Retain boot service code until after switching to
>>  virtual mode
> 
> That's not a long-term option, since we have no way to distinguish 
> between a machine that requires boot services code to be mapped and a 
> machine that doesn't. Reverting just breaks the former set again. 

what former? you can not fix some corner case by breaking most other cases.

> We need to ensure that the kernel isn't overlapping boot services code.

bootloader will put kernel from 16M, and boot services are on those area already.

Yinghai
