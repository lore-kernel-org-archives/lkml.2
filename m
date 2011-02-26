Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1BZWqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:46:34 -0500
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:53518 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1BZWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:46:33 -0500
X-Greylist: delayed 2624 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Feb 2011 17:46:32 EST
Message-ID: <4D697881.4050409@ece.ntua.gr>
Date: Sun, 27 Feb 2011 00:02:41 +0200
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110225 Lightning/1.0b3pre Lanikai/3.1.7
MIME-Version: 1.0
To: Alvaro Aguilera <alvaro.aguilera@mailbox.tu-dresden.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about the vmlinuz file
References: <AANLkTimtj=8ikdzgUiaT+y1MsjfGNU3LcyaUMPU0wMEh@mail.gmail.com>
In-Reply-To: <AANLkTimtj=8ikdzgUiaT+y1MsjfGNU3LcyaUMPU0wMEh@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Sun, 27 Feb 2011 00:02:45 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 02:25 PM, Alvaro Aguilera wrote:
> Hello,
>
> perhaps someone here has a couple of minutes to explain me the
> difference between these two vmlinuz files from different
> distributions:
>
> $file /boot/vmlinuz
> /boot/vmlinuz-2.6.37-40-desktop: Linux/x86 Kernel, Setup Version
> 0x20a, bzImage, Version 2.6.37, Version 2.6.37-40, RO-rootFS, root_dev
> 0x301, swap_dev 0x4, Normal VGA
>
> $file /boot/vmlinuz
> vmlinuz: ELF 64-bit LSB shared object, AMD x86-64, version 1, stripped
>
> the second file seems to be in ELF format and I cannot use it with my
> cluster management software.
>
> Is there a parameter I can use to compile the kernel image in one
> format or the other? or a tool to convert them?
>
> I couldn't find any hint on Google, nor I really know what exactly to look for.
>
> Thanks for any help.
> Alvaro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml
http://en.wikipedia.org/wiki/Vmlinux

You can find lots of info by googling vmlinux or bzImage.

Afaik, the first is a bzImage, ie a compressed and stripped down version
of the vmlinux executable(which is the second one).

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

