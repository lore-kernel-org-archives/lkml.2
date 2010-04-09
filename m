Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0DIW1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:27:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43604 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0DIW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:26:59 -0400
Message-ID: <4BBFA9BF.60608@oracle.com>
Date: Fri, 09 Apr 2010 15:27:11 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio> <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org>
In-Reply-To: <20100409222103.GA11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBFA963.00AD:SCFMA4539814,ss=1,pt=DBB_66871,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:21 PM, Andy Isaacson wrote:
> On Fri, Apr 09, 2010 at 12:55:39PM -0700, Yinghai wrote:
>   
>> update version for test
>>
>> Subject: [PATCH] x86: reserve [0xa0000, 0x100000] in e820
>>
>> Update e820 at first, and later put them resource tree.
>> But give pci BAR chance to claim the range, before assign unassigned resources.
>>
>> In case some system doesn't have VGA, and use [0xa0000, ..] for mmio of some
>> other pci devices.
>>     
> This doesn't help, my AHCI still fails to initialize in the same way.
>
>   
bootlog?

what is the address used for AHCI?

YH
