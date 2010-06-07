Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0FGSeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:34:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60761 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0FGSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TGN4gGpXpt/SvvdzfQR1G8iD+VWqnx3Dr8j4CPwsXdDK+fcr/041psQUu8f7xGBKHA
         GPFER2ncFYroFpihdMZG7E1x5x6GgjdaQ0QSHQJy0LKsxsWBWPIf9GRsz/tuwdFja314
         2xIbo/KCJgw8DlLlHVymWLcc9AIfw8H/C52Tw=
Message-ID: <4C0D3BBE.9020601@gmail.com>
Date: Mon, 07 Jun 2010 11:34:38 -0700
From: DanVolkman <danvolkman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, ariveira@gmail.com
Subject: Re: Kernel 2.6.32-22-generic sata problems
References: <4C0A6326.1090100@gmail.com> <4C0B5307.1020206@gmail.com>
In-Reply-To: <4C0B5307.1020206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you guys for responding to me email.

I did what you asked and it was nice to be able to see what messages 
were being generated.  In my debugging efforts I made one mistake, I 
replaced the motherboard with the exact same brand/model motherboard 
(different firmware though), I wish I would have had a different one 
around the house.  Anyway, it appears that the one month old drive I had 
mounted failed and happened to coincide with the OS upgrade.  I was not 
using that drive and something seems suspicious because this is the 
second new drive that has failed and these are drives from a reputable 
company.  With the changes in place you recommended I saw:

ata3.01: status: { DRDY ERR }
ata3.01: error: { UNC }
ata3.01: configured for UDMA/133
ata3: EH complete

This code would loop with occasional other messages.  I unhooked my good 
drive and used the Ubuntu distribution CD and booted up into "try 
Ubuntu" mode and used the disk utility and it said the drive was bad.  I 
am not sure if this is a drive problem or a motherboard problem, maybe I 
will replace both.  Yes, I did try different SATA cables and sockets.

Anyway, sorry to bother you guys but you did help me identify the problem.

Dan
DanVolkman@gmail.com


On 10-06-06 12:49 AM, Robert Hancock wrote:
> On 06/05/2010 08:45 AM, DanVolkman wrote:
>> SYNOPSES
>> ==========
>> Kernel fails to boot when multiple SATA drives are connected. After a
>> day of working on the problem (changing cables, sata positions,
>> motherboards, CPUs, power supplies, etc.) I discovered that with only
>> the boot drive connected everything worked fine.
>>
>> BACKGROUND
>> =============
>> I had a career in UNIX so it is common for me to use cpio(1), tar(1),
>> dump(1), and dd(1) to replicate disks but have not been able to do so
>> with two SATA disks connected using older kernels but with this new
>> kernel I could not even have the second disk connected.
>>
>> PROBLEM APPEARED WHEN
>> ======================
>> An Ubuntu kernel update stopped my computer from booting. I have no
>> backup computer so my description is sketchy because I was not willing
>> to use a pencil and write the lengthy terse information. Boot error
>> message was something like:
>>
>> Gave up waiting for root device. Common problems:0f106d71e58
>> ...
>> ALERT! /dev/disk/by-uuid/..... does not exist. Dropping to a shell!
>
> Can you get any of the libata messages showing up on the console? You 
> might need to change grub options to boot with more debug displayed 
> (don't know how to do that offhand on Ubuntu).
>

