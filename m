Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0DLT7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:59:13 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:59903 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0DLT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:59:12 -0400
References: <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org> <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org> <4BC375D9.4040503@oracle.com> <20100412194853.GN11130@hexapodia.org>
Message-Id: <0FCFFDBC-153F-4D99-8EE3-E0C4C4EC2A45@oracle.com>
From: "yinghai.lu@oracle.com" <yinghai.lu@oracle.com>
To: Andy Isaacson <adi@hexapodia.org>
In-Reply-To: <20100412194853.GN11130@hexapodia.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as x86_32
Date: Mon, 12 Apr 2010 12:55:57 -0700
Cc: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC37B4D.0054:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Apr 12, 2010, at 12:48 PM, Andy Isaacson <adi@hexapodia.org> wrote:

> On Mon, Apr 12, 2010 at 12:34:49PM -0700, Yinghai wrote:
>> On 04/12/2010 11:54 AM, Andy Isaacson wrote:
>>> On Fri, Apr 09, 2010 at 07:46:04PM -0700, Yinghai wrote:
>>> [    5.463672] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low)  
>>> -> IRQ 20
>>> [    5.470633] ahci 0000:00:1f.2: BAR 5: can't reserve [mem  
>>> 0x000a0000-0x000a07ff]
>>> [    5.478257] ahci: probe of 0000:00:1f.2 failed with error -16
>>
>> please check
>>
>> [PATCH] x86,pci, acpi: Inherent BUSY flag when setup_resource for  
>> root bus
>
> What patches should I have applied?  I'm testing with d620a7cf from
> linus' tree, plus your "reserve [0xa0000,0x1000000] in e820", plus  
> this
> patch.
Yes
