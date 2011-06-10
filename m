Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1FJXzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:55:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61826 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab1FJXzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:55:47 -0400
Message-ID: <4DF2AEEF.6040208@kernel.org>
Date: Fri, 10 Jun 2011 16:55:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <4DF2A17E.7000103@kernel.org> <20110610230359.GA2084@srcf.ucam.org> <4DF2A81C.7000902@kernel.org> <4DF2A984.6060705@linux.intel.com>
In-Reply-To: <4DF2A984.6060705@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DF2AEF9.0040,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 04:32 PM, H. Peter Anvin wrote:
> On 06/10/2011 04:26 PM, Yinghai Lu wrote:
>>>
>>>> 2. ask vendor of system that Matthew try to fix to go back fix their firmware. otherwise user have stay with CSM with it.
>>>
>>> This isn't an option.
>>>
>>> The medium-term fix is to ensure that the bootloaders don't put the 
>>> kernel on top of boot services code. 
>>
>> that is not enough, will need to make arch/x86/boot/compressed/head_64.S parse e820 table to find right decompress position.
>>
> 
> No, it should be, because the boot loader can control the decompress
> position to avoid the problems.

bootloader could find out decompressed kernel size?

Yinghai
