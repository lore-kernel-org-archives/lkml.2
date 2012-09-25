Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2IYTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:08:36 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40456 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2IYTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:08:35 -0400
Message-ID: <506200FD.2060305@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 00:37:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Carlos Moffat <carlos@eldiabloenlosdetalles.net>
CC: linux-kernel@vger.kernel.org, computersforpeace@gmail.com,
        ming.m.lin@intel.com, Norbert Preining <preining@logic.at>,
        jgarzik@pobox.com, Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: Slow Resume with SSD
References: <5061F84B.3030603@eldiabloenlosdetalles.net>
In-Reply-To: <5061F84B.3030603@eldiabloenlosdetalles.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092519-2674-0000-0000-0000061BFB8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 12:00 AM, Carlos Moffat wrote:
> Hi,
> 
> (please let me know if this is the wrong list to ask this)
> 
> I have a Crucial M4 512 GB SSD installed on my Thinkpad X220 (Ubuntu
> Precise). Overall this runs very nicely, but it takes 10+ seconds to
> resume from suspend, apparently because some issue with the hardrive.
> The only message I see while resuming is "COMRESET failed (errno=-16)".
> 
> [52483.228615] ata1: link is slow to respond, please be patient (ready=0)
> [52487.870616] ata1: COMRESET failed (errno=-16)
> [52488.190222] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [52488.190752] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
> succeeded
> [52488.190754] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
> LOCK) filtered out
> [52488.190755] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [52488.191849] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
> succeeded
> [52488.191855] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
> LOCK) filtered out
> [52488.191860] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [52488.192406] ata1.00: configured for UDMA/100
> [52488.206298] sd 0:0:0:0: [sda] Starting disk
> [52488.207334] Extended CMOS year: 2000
> [52488.208335] PM: resume of devices complete after 10376.896 msecs
> [52488.208552] PM: resume devices took 10.376 seconds
> 
> The only relevant post I've found was in the crucial support site:
> 
> http://forums.crucial.com/t5/Solid-State-Drives-SSD/SOLVED-M4-CT512M4SSD1-7mm-512Gb-SSD-too-slow-when-laptop-wakes/td-p/102666
> 
> 
> which suggested adding libata.force=nohrst as a boot option to get rid
> of the problem.
> 
> I tried that, but the laptop wouldn't suspend.
> 
> Any ideas?
> 

(Adding relevant people to CC)

I recall seeing a similar problem getting fixed in mainline quite a long
time ago (around v3.3 I think). Did you try the latest mainline kernel?
 
Regards,
Srivatsa S. Bhat

