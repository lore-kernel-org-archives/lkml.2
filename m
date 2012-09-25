Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2IYSbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:31:18 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:50318 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2IYSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:31:17 -0400
Message-ID: <5061F84B.3030603@eldiabloenlosdetalles.net>
Date: Tue, 25 Sep 2012 11:30:35 -0700
From: Carlos Moffat <carlos@eldiabloenlosdetalles.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Slow Resume with SSD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(please let me know if this is the wrong list to ask this)

I have a Crucial M4 512 GB SSD installed on my Thinkpad X220 (Ubuntu 
Precise). Overall this runs very nicely, but it takes 10+ seconds to 
resume from suspend, apparently because some issue with the hardrive. 
The only message I see while resuming is "COMRESET failed (errno=-16)".

[52483.228615] ata1: link is slow to respond, please be patient (ready=0)
[52487.870616] ata1: COMRESET failed (errno=-16)
[52488.190222] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[52488.190752] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) 
succeeded
[52488.190754] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE 
LOCK) filtered out
[52488.190755] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) 
filtered out
[52488.191849] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) 
succeeded
[52488.191855] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE 
LOCK) filtered out
[52488.191860] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) 
filtered out
[52488.192406] ata1.00: configured for UDMA/100
[52488.206298] sd 0:0:0:0: [sda] Starting disk
[52488.207334] Extended CMOS year: 2000
[52488.208335] PM: resume of devices complete after 10376.896 msecs
[52488.208552] PM: resume devices took 10.376 seconds

The only relevant post I've found was in the crucial support site:

http://forums.crucial.com/t5/Solid-State-Drives-SSD/SOLVED-M4-CT512M4SSD1-7mm-512Gb-SSD-too-slow-when-laptop-wakes/td-p/102666

which suggested adding libata.force=nohrst as a boot option to get rid 
of the problem.

I tried that, but the laptop wouldn't suspend.

Any ideas?

Thanks,
Carlos

-- 
kernel-team mailing list
kernel-team@lists.ubuntu.com
https://lists.ubuntu.com/mailman/listinfo/kernel-team
