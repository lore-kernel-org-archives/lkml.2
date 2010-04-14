Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0DNTxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:53:10 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45835 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0DNTxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:53:08 -0400
Message-ID: <4BC61C46.4040609@oracle.com>
Date: Wed, 14 Apr 2010 12:49:26 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Yinghai <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC51312.6080302@oracle.com> <20100414192546.GA11130@hexapodia.org> <4BC6172C.6060001@oracle.com> <20100414194312.GB11130@hexapodia.org>
In-Reply-To: <20100414194312.GB11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BC61CFC.00D3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 12:43 PM, Andy Isaacson wrote:
> On Wed, Apr 14, 2010 at 12:27:40PM -0700, Yinghai wrote:
>>> I'll attach the dmesg to bug 15744.
>>
>> thanks. please put /proc/iomem there too.
> 
> I attached it to the bug.

looks good.

000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : reserved
000c0000-000effff : PCI Bus 0000:00
  000c0000-000effff : reserved
000f0000-000fffff : PCI Bus 0000:00
  000f0000-000fffff : reserved

Thanks

Yinghai
