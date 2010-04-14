Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0DNTaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:30:08 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:45990 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0DNTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:30:06 -0400
Message-ID: <4BC6172C.6060001@oracle.com>
Date: Wed, 14 Apr 2010 12:27:40 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org> <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC51312.6080302@oracle.com> <20100414192546.GA11130@hexapodia.org>
In-Reply-To: <20100414192546.GA11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4BC6177F.00DA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 12:25 PM, Andy Isaacson wrote:
> On Tue, Apr 13, 2010 at 05:57:54PM -0700, Yinghai wrote:
>> On 04/13/2010 02:58 PM, H. Peter Anvin wrote:
>>> That's not good (in general - for devices in this particular range it's
>>> not such a big deal, but it is potentially really bad for devices marked
>>> reserved for them not to be moved.)
>>>
>>> We have talked about a need to resolve this before.
>>
>> this one should make both cases work.
>>
>> Andy, can you check this one together with
>> v3: x86: Reserve [0xa0000, 0x100000] in e820 map
> 
> I've booted successfully with the patch below, on top of the patch in
> Message-ID: <4BC4E09F.9000608@oracle.com>
> 
> I'll attach the dmesg to bug 15744.

thanks. please put /proc/iomem there too.

Yinghai
