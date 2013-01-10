Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3AJRdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:33:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53868 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3AJRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:33:54 -0500
Message-ID: <50EEFB62.2090303@gmail.com>
Date: Thu, 10 Jan 2013 09:33:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yves DUF <yves.duf@laposte.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: Help on Driver touchkit_ps2.c
References: <CANe8kDHzsfnXJGtqrJUSwnRm2apQSc2WKCLhwQAayUog=wdPsA@mail.gmail.com>
In-Reply-To: <CANe8kDHzsfnXJGtqrJUSwnRm2apQSc2WKCLhwQAayUog=wdPsA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 02:07 PM, Yves DUF wrote:
> Hello Mister Mattock.
>
> I hope this email will not bother you. It's about the eGalax
> Touchscreen driver you modify more or less recently.
>
> I try to use it on a archos 9 tablet PC, with tricks from that link and others:
> http://forum.archosfans.com/viewtopic.php?f=50&t=27303
>
> But no matter how hard I try, the touchscreen doesn't work on my archos 9
> PC tablet. I use the nomux option, the good serio1 on raw_device, the
> module is present ... But it's impossible to install the eGalaxy
> driver, I fall on the "no PS2 mouse present".
>
> I've tried this on Ubuntu 12.04 (with both vanilla & recompiled kernel to
> add touchkit.c module), debian 6.06 (kernel 2.6.32) and Bodhi linux (kernel
> 3.5) and to version of eGalaxy userland driver (the latest, and an old one
> 3.07)
>
> In fact the touch_kit_detect function failed on the first ps2_command
> (when it tried to send the 0xA 1 0xE.
>
> I'm sorry to bother you, but if you got some clue to make the touch screen
> work, I would be very gratefull.
>
> Yves.
>


from what I remember I just fixed some web addresses(no real code 
changes). best thing for you to do is try to contact the 
authors/maintainers of the code so that they can fix their code.

I added some Cc's

cheers,

Justin P. Mattock
