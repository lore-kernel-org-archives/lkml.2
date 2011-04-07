Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1DGJVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:21:04 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55106 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1DGJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:21:03 -0400
Message-ID: <4D9D81ED.7090809@ahsoftware.de>
Date: Thu, 07 Apr 2011 11:20:45 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nico Erfurth <ne@erfurth.eu>
CC: Eric Cooper <ecc@cmu.edu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and Seagate
 DockStars
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <4D9CEE24.1080501@erfurth.eu>
In-Reply-To: <4D9CEE24.1080501@erfurth.eu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.04.2011 00:50, schrieb Nico Erfurth:
> Alexander Holler wrote:
>
>> The first patch merges the setup for Seagate DockStars into the setup
>> for Marvell SheevaPlugs and the second one removes the machine type for
>> DockStars at all.
>
> That looks fine so far.
>
>> Removing the machine type for DockStar shouldn't be a big problem. Support
>> for them is already broken in mainline U-Boot since 2 versions, so changing the
>> stuff there is already needed and it shouldn't be a problem to use the same
>> machine type as used for SheevaPlugs there.
>
> This sounds like very bad reasoning to me. The Dockstar has a machine-id
> assigned, if the bootloader is broken, people should either use a
> working version, or fix the current one.
>
> Also, using the memory-size to differ between these two machines sounds
> like something thats doomed to fail in the future.

I wonder how many people believe that either there will be another 
DockStar with the same HW and GPIOs for the LEDs but more memory (and 
still without sata) or that there will be another SheevaPlug with just 
128MB RAM or that someone could have a reason to change the memory 
layout using a mem= parameter.

For me all that is pretty unlikely.

Anyway, if someone wants, he could just use my patch 1/2 and replace 
patch 2/2 with a patch which changes the one line which checks the 
memory layout to be one bank with 128MB to machine_is_dockstar().

Regards,

Alexander
