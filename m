Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1AIBQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 20:16:39 -0500
Received: from smtp12.ono.com ([62.42.230.20]:32306 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910Ab1AIBQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 20:16:38 -0500
Message-ID: <4D290C63.9040005@ono.com>
Date: Sun, 09 Jan 2011 02:16:19 +0100
From: carlos palma <carlos.palma@ono.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #25402] kernel (2.6.37-8-generic_amd64) panic on boot (with
 message "map_single: bounce buffer is not DMA'ble) - possible regression
 !!!
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.txE.R-7GNB@chimera> <4D1CFA99.1070701@ono.com> <201012302351.48156.rjw@sisk.pl>
In-Reply-To: <201012302351.48156.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.
I've found the same bug reported in redhat 
(https://bugzilla.redhat.com/show_bug.cgi?id=668088).
carlos


On 12/30/2010 11:51 PM, Rafael J. Wysocki wrote:
> On Thursday, December 30, 2010, carlos palma wrote:
>> I can confirm that this "regression" still exists with the kernel
>> 2.6.37-rc8.
>> The Call Trace is basically the same:
>>
>> ...
>> Kernel panic - not syncing: map_single ...
>> Pid 935, comm: NetworkManager Tainted
>> call trace
>> panic+oxbf/0x200
>> ? default_spin_lock_flags+0x9/0x10
>> ?swiotlb_tlb_map_single+0x1ce/0x250
>> ?map_single+0x46/0x60
>> swiotlb_map_page+0xa6/0xf
>> ... and then the FREEZE ... only a hard reset brings to live (with
>> 2.6.36-2) Linux.
> Thanks for the info.
>
> Why did you put "regression" into double quotes?
>
> Rafael
>

