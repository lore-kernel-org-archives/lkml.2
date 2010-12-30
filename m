Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0L3Vin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 16:38:43 -0500
Received: from smtp13.ono.com ([62.42.230.16]:26805 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342Ab0L3Vil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 16:38:41 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 16:38:41 EST
Message-ID: <4D1CFA99.1070701@ono.com>
Date: Thu, 30 Dec 2010 22:33:13 +0100
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
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.txE.R-7GNB@chimera>
In-Reply-To: <sV7shrPOroO.A.txE.R-7GNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that this "regression" still exists with the kernel 
2.6.37-rc8.
The Call Trace is basically the same:

...
Kernel panic - not syncing: map_single ...
Pid 935, comm: NetworkManager Tainted
call trace
panic+oxbf/0x200
? default_spin_lock_flags+0x9/0x10
?swiotlb_tlb_map_single+0x1ce/0x250
?map_single+0x46/0x60
swiotlb_map_page+0xa6/0xf
... and then the FREEZE ... only a hard reset brings to live (with 
2.6.36-2) Linux.

carlos.


On 12/30/2010 12:07 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	:http://bugzilla.kernel.org/show_bug.cgi?id=25402
> Subject		: kernel (2.6.37-8-generic_amd64) panic on boot (with message "map_single: bounce buffer is not DMA'ble) - possible regression !!!
> Submitter	: carlos<carlos.palma@ono.com>
> Date		: 2010-12-21 19:58 (9 days old)
>
>
>

