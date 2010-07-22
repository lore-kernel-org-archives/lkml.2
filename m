Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0GVSV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:21:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46829 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0GVSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:21:25 -0400
Message-ID: <4C488C0C.5080409@oracle.com>
Date: Thu, 22 Jul 2010 11:21:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: tanaka <tanaka_hideo@yahoo.co.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please teach me X86 I/O port 0x61
References: <20100722175727.43642.qmail@web100105.mail.kks.yahoo.co.jp>
In-Reply-To: <20100722175727.43642.qmail@web100105.mail.kks.yahoo.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C488C22.01B2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/10 10:57, tanaka wrote:
> Good evening. Dear all.
> 
> I appreciate your responses.
> We use AMD CPU machine.
> 
> For example,
> http://www.sun.com/servers/entry/x4100/arch-wp.pdf
> 
> In Figure 1-1 block diagram (page 10) ,
> which device is mapped 0x61 address in ?

I can't tell from that block diagram.  I tried to see if 0x61 is part of
the AMD-8111 chipset, but it seems that they have removed all downloads
from that web page
(http://www.amd.com/us/products/embedded/chipsets/Pages/other-embedded-chipset-products.aspx,
last 3 links are bad).

I would expect 0x61 to be part of the 8111 or possibly 8132 chipset.


> --- Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Fri, 16 Jul 2010 00:00:36 +0900 (JST) tanaka wrote:
>>
>>> Dear all.
>>>
>>> I investigate about  NMI kernel messages.
>>> Linux kernel read 0x61 address using inb(61h).
>>>
>>> I search a amd opteron cpu following manuals.
>>> but I do not find  explanation of 0x61 address.
>>>
>>>
>>
> http://support.amd.com/us/psearch/Pages/psearch.aspx?type=2.1&product=2.1.4&contentType=Tech+Doc+Processor&ostype=&keywords=&items=20
>>>
>>> Could you teach me a 0x61 address of X86 arch >
>>
>> Hi,
>>
>> IO port 0x61 (NMI Status & Control register) is not CPU-specific on
>> x86.
>> It's more of a platform thing.
>>
>> Intel describes it in ICH (chipset) specs, e.g., ICH7 spec,
>> section 10.7.1.  Please try that and see if it answers your
>> questions.
>>
>> ---


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
