Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2BAP1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:27:32 -0500
Received: from mail.yuiop.co.uk ([89.145.97.74]:46282 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab2BAP1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:27:31 -0500
Message-ID: <4F2959FA.70101@anonymous.org.uk>
Date: Wed, 01 Feb 2012 15:27:54 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: thomas@fjellstrom.ca, linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca> <4F295769.6070003@suse.de>
In-Reply-To: <4F295769.6070003@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 15:16, Hannes Reinecke wrote:
> On 02/01/2012 03:42 PM, Thomas Fjellstrom wrote:
>> On Wed Feb 1, 2012, John Robinson wrote:
>>> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
>>> [...]
>>>>  I picked up a refurb IBM
>>>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just have
>>>> to wait and see why grub doesn't like it.
>>>
>>> When you find out, please let me know - I bought one via ebay, its
>>> firmware was elderly and wouldn't let me put it in JBOD mode, after a
>>> bit of googling I flashed it with IBM's latest firmware, then GRUB
>>> thought my machine had no RAM in it.
[...]
>
> From my experience the BIOS wouldn't present any disks in JBOD mode.
> So you'd be needing to switch to RAID mode first.

The firmware my card came with didn't have a JBOD mode, which is why I 
flashed the newer firmware. Then I could boot in JBOD mode from a rescue 
CD and see some drives, though not those that had had RAID-mode metadata 
written to them, but I couldn't boot the system with GRUB (from drives 
on another controller).

Cheers,

John.
