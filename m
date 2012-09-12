Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab2ILIKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:10:37 -0400
Received: from px.televes.com ([212.163.42.136]:56730 "EHLO px.televes.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2ILIKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:10:25 -0400
Message-ID: <505042A8.2090904@televes.com>
Date: Wed, 12 Sep 2012 10:07:04 +0200
From: Jorge Dominguez <jmadom@televes.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux based bootloader
References: <50504192.9050201@televes.com>
In-Reply-To: <50504192.9050201@televes.com>
X-Forwarded-Message-Id: <50504192.9050201@televes.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HiGeert,

Excuse me for my lack of boldness when searching on Internet

Best Regards,
Jorge

El 12/09/2012 9:57, Geert Uytterhoeven escribió:
> Hi Jorge,
>
> On Wed, Sep 12, 2012 at 9:25 AM, Jorge Dominguez<jmadom@televes.com>  wrote:
>> I find link on Web that describes a module to load other linux kernel or
>> bootloader with a commandline params inside a linux.
>>
>> Works are perform by bootloader kernel module that get kernel, initrd and
>> command line params.
>>
>> http://www.embeddedarm.com/software/arm-linux-bootloader.php
>>
>> Unfortunately, this module has been developed by a private company and
>> payment.
>>
>> All embedded developers are waiting for a module of its kind in the kernel
>> but open source and would greatly facilitate the development of the kernel
>> for these systems without having to flash the kernel or loaded via nfs or
>> other boot method.
>>
>> Send this email after looking at some kernel module that can do this work..
>> Would be very grateful if you could tell me something about it.
>>
>> I don´t subscribe to linux-kernel mailing list, Please send me a CC'ed
>> response
> What about kexec and kboot/petitboot?
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>


