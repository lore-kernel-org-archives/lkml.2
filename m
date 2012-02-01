Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2BAPRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:17:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2BAPQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:16:59 -0500
Message-ID: <4F295769.6070003@suse.de>
Date: Wed, 01 Feb 2012 16:16:57 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: thomas@fjellstrom.ca
Cc: John Robinson <john.robinson@anonymous.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca>
In-Reply-To: <201202010742.07818.thomas@fjellstrom.ca>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 03:42 PM, Thomas Fjellstrom wrote:
> On Wed Feb 1, 2012, John Robinson wrote:
>> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
>> [...]
>>
>>>  I picked up a refurb IBM
>>>
>>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just have
>>> to wait and see why grub doesn't like it.
>>
>> When you find out, please let me know - I bought one via ebay, its
>> firmware was elderly and wouldn't let me put it in JBOD mode, after a
>> bit of googling I flashed it with IBM's latest firmware, then GRUB
>> thought my machine had no RAM in it. The card has been sitting in a box
>> since.
> 
> Yeah, GRUB immediately throws an "out of memory. Aborted" error, its annoying, 
> but I reported the issue on GRUB's bug tracker after talking to a guy in #grub 
> on freenode. Hopefully someone looks at it soon. It appears it happens so 
> early in grub's startup that it can't even output any debug info (I was asked 
> to run: `grub-install --debug-image=all /dev/sdX`, and did so, I get debug 
> output when the card is not installed, but absolutely nothing when it is 
> installed.
> 
>From my experience the BIOS wouldn't present any disks in JBOD mode.
So you'd be needing to switch to RAID mode first.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
