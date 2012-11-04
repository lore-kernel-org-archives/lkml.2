Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2KDRTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:19:46 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:35490 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2KDRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:19:44 -0500
Message-ID: <5096A3A4.8070602@ahsoftware.de>
Date: Sun, 04 Nov 2012 18:19:32 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
References: <5093A592.9070605@ahsoftware.de> <5093D069.20901@ahsoftware.de> <20121103044929.GB21829@liondog.tnic> <5094F5C5.1000000@ahsoftware.de> <20121104152133.GA16116@x1.osrc.amd.com>
In-Reply-To: <20121104152133.GA16116@x1.osrc.amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.11.2012 16:21, schrieb Borislav Petkov:
> On Sat, Nov 03, 2012 at 11:45:25AM +0100, Alexander Holler wrote:
>> Hmm, exactly that just happened twice in a row. Unfortunately the
>> screen was already disabled (screen saving mode), so I couldn't see
>> any message, if there was any. Just a dead box (not overclocked, I
>> don't do such, I even had enabled the power saving mode in the BIOS,
>> which seems to mean max. 3800 MHz). I think I should start getting
>> nervous. :(
>
> How do you know this happened twice if you couldn't see any message?

I was remotely logged in and there aren't that many faults which lead to 
complete stand still of hw (no reset).

But as you said I can't know, the only thing I know is that a box with 
new mb, memory and apu come to a complete stand still, and such shortly 
after I've received an emergency message which told me that a bit inside 
the cpu switched unexpected. Adding to that, the box did the same as 
what it did while it received the MCE, a backup from a sata-atached ssd 
to an usb3-hd which includes compression and encryption which keeps all 
cores at work most of the time for several hours.

> Also, can you enable netconsole or serial console, if possible, and try
> to catch full dmesg from the boot and up until it happens.

As I was logged in remotely by network, I know it wasn't the same MCE as 
before (just a disconnect and dead hw). But I don't know what else it 
was. And as I recently got hit by a broken RAM module, which was a pain 
to find, I'm not very happy that I have to go through similiar pain 
again with new HW.

The probability to get a working HW and SW combination just has become 
to low in the last years. All the (IT) companies better should spend the 
money they now give their lawyers their QA and engineering departments 
instead.

Sorry for the rant, also I'm used to live with hw and sw errors (as a 
sw-dev), I'm currently just a bit annoyed. ;)

I will setup something to monitor the box through the serial and will 
let it backup itself all the time, trying to catch some usefull information.

Regards,

Alexander
