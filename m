Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3AIOEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:04:24 -0500
Received: from plane.gmane.org ([80.91.229.3]:37594 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911Ab3AIOEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:04:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: Re: 3.2.35 problem with M5A97 PRO ram: bad_page free_pages_prepare
 mem_init
Date: Wed, 09 Jan 2013 15:04:00 +0100
Organization: tigusoft.pl
Message-ID: <kcjtcf$iqd$1@ger.gmane.org>
References: <kcfoae$91e$1@ger.gmane.org> <kcfoq8$dac$1@ger.gmane.org> <20130108155923.GA8350@liondog.tnic> <kcj877$d31$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bolobolo1.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
In-Reply-To: <kcj877$d31$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/13 09:02, lkml@tigusoft.pl wrote:
> On 08/01/13 16:59, Borislav Petkov wrote:
>> On Tue, Jan 08, 2013 at 01:21:26AM +0100, lkml@tigusoft.pl wrote:
>>> On 08/01/13 01:13, lkml@tigusoft.pl wrote:
>>>
>>>> linux kernel
>>>> 3.2.0-0.bpo.4-rt-amd64 #1 SMP PREEMPT RT Debian 3.2.35-2~bpo60+1 x86_64
>>>> GNU/Linux
>>>
>>> will post later how it behaves on vanilla 3.2.36 and 3.7.1
>>
>> Yes, also, if your DRAM supports ECC, try enabling it in the BIOS.
>> This board should support ECC. Then, enable CONFIG_EDAC_AMD64 and
>> CONFIG_EDAC_DECODE_MCE to check whether it catches any DRAM errors.
>>
>> If your DRAM is non-ECC, try consecutively swapping out a DIMM each time
>> and booting to see whether removing one of the DIMMs makes the errors go
>> away.
>>
>> HTH.
>>
> 
> Thank you;
> On vanilla 3.2.36 there is the same problem.
> 
> Also problems happen on each boot so not random memory error, but I will
> try to swap rams, run memtest and so on.

Turned out it was just a hardware problem after all.
Solution is simply to try good memtest86 memory tester and swap out bad
chip.

Sorry for the trouble, thanks.


