Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0KBPpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:45:22 -0400
Received: from nitrogen.vapor.com ([213.203.212.226]:35292 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0KBPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:45:17 -0400
Date: Tue, 2 Nov 2010 16:45:13 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
X-X-Sender: pomac@twilight.pomac.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: High [extra timer interrupt] count in powertop since 2.6.36
In-Reply-To: <4CCEE740.3080108@goop.org>
Message-ID: <alpine.LNX.2.00.1011012154210.24290@twilight.pomac.com>
References: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com> <4CCEE740.3080108@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Jeremy Fitzhardinge wrote:

> On 10/30/2010 07:52 PM, Ian Kumlien wrote:
>> Hi,
>>
>> I have been searching the list for anyone else seeing this,
>> but i haven't found anything yet - Any ideas on how to debug?
>>
>> From powertop:
>> Top causes for wakeups:
>>   84.7% (1673.3)   [extra timer interrupt]
>>
>> Thats a little bit high in my opinion, for some reason it seems to be
>> ignored since the actual number of wakeups seems to be ~367 or so.
>>
>> Ideas? Suggestions?
>
> I'm not sure, but I'm seeing something similar.

using powertop: 1.13

< Detailed C-state information is not P-states (frequencies)
                                         3.21 Ghz     6.0%
                                         2.40 Ghz     0.0%
                                         1.60 Ghz     0.1%
                                          800 Mhz    93.9%


Wakeups-from-idle per second : 441.8    interval: 10.0s 
no ACPI power usage estimate available

Top causes for wakeups:
   84.3% (2132.0)   [extra timer interrupt]
    8.1% (205.4)   qemu-system-x86
    2.4% ( 61.0)   [eth1] <interrupt>
    1.2% ( 31.1)   [eth0] <interrupt>
    1.2% ( 29.3)   java
    1.0% ( 26.3)   [ahci] <interrupt>
    0.5% ( 13.0)   [sky2@pci:0000:05:00.0] <interrupt>
    0.5% ( 12.0)   kworker/u:2
...

Has any output been changed, is this just a missenterpetation done by powertop?

CPU: AMD Phenom(tm) II X6 1090T Processor

>    J
>
>
