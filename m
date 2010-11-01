Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab0KANWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:22:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50892 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab0KANWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OFcAOT68lU3IzvmfZloMMsefPwDCNviUnb4P1vuC/5jZr4rjgIEblqPB57zQ6e7+Mc
         ORMq1T8SSfqagSTWjFQYNOzhPsUEPg8l+Bled2QlMaCEspdNbWZ/bKyA8CNVKDTsc33Y
         mfN4S15HxLqUB+FdZ0LcGUfuyf3uaNbD0ZrIE=
MIME-Version: 1.0
In-Reply-To: <6631e123845856ac20423c25e07844c8@mail.gmail.com>
References: <Act3331keWjsN/sHTZGScnUum3AwDw==>
	<6631e123845856ac20423c25e07844c8@mail.gmail.com>
Date: Mon, 1 Nov 2010 09:22:45 -0400
Message-ID: <AANLkTikWWGpAM8+_z9fnngYuYSpT3NWgM7xeGkOzZ3jg@mail.gmail.com>
Subject: Re: All Applied micro boards are failing with current mainline kernel
From: Josh Boyer <jwboyer@gmail.com>
To: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 11:06 PM, Rupjyoti Sarmah <rsarmah@apm.com> wrote:
> Hi ,
>
> APM boards Canyonlands/Kilauea/Glacier/Katmai/Sequoia are all failing
> during booting.

What kernel version?  What config?  Have you tried a git bisect to see
when it broke?  Etc, etc.

Also, CC'ing linuxppc-dev would have been a good idea.  Not many on
lkml are even going to know what you're talking about with such sparse
details.

josh

>
> Call trace is same for all
>
>
> Call Trace:
>
> [df835d70] [c02d27cc] emac_probe+0xf28/0x12a8 (unreliable)
>
> [df835e50] [c023c7cc] platform_driver_probe_shim+0x40/0x54
>
> [df835e60] [c01bf354] platform_drv_probe+0x20/0x30
>
> [df835e70] [c01bde68] driver_probe_device+0x148/0x1ac
>
> [df835e90] [c01be17c] __driver_attach+0xa4/0xa8
>
> [df835eb0] [c01bcfa4] bus_for_each_dev+0x60/0x9c
>
> [df835ee0] [c01bdbbc] driver_attach+0x24/0x34
>
> [df835ef0] [c01bd94c] bus_add_driver+0x1b8/0x274
>
> [df835f20] [c01be3d8] driver_register+0x6c/0x160
>
> [df835f40] [c01bf6c4] platform_driver_register+0x68/0x78
>
> [df835f50] [c023c998] of_register_platform_driver+0xa8/0xc4
>
> [df835f60] [c0393e88] emac_init+0x1ac/0x1dc
>
> [df835fa0] [c0001574] do_one_initcall+0x160/0x1a8
>
> [df835fd0] [c037a1e8] kernel_init+0xcc/0x174
>
> [df835ff0] [c000c5b0] kernel_thread+0x4c/0x68
>
> Instruction dump:
>
> 419e016c 2f800007 419e0164 38130774 901a00d0 381306b0 901a00d4 7f43d378
>
> 4bf91d89 817a01a0 39200001 380b0008 <7d400028> 7d4a4b78 7d40012d 40a2fff4
>
> ---[ end trace dac0cf4779f83901 ]---
>
>
> Regards,
> Rup
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
