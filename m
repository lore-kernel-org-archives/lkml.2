Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab2GLVYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:24:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42055 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab2GLVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <4FFEF71E.7080706@xenotime.net>
References: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au>
	<4FFEF71E.7080706@xenotime.net>
Date: Thu, 12 Jul 2012 15:24:15 -0600
Message-ID: <CAL-B5D1a=OX9nuVpLFNhwfarq-WBgYbAh6w8+2deH7w0iY0NCg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 12 (pci)
From: Myron Stowe <myron.stowe@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:11 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/11/2012 11:03 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120710:
>>
>>
>> The pci tree lost its conflicts.
>
>
> on x86_64:
>
> drivers/built-in.o: In function `pci_bus_add_device':
> (.text+0x4f62): undefined reference to `pci_fixup_final_inited'
>
>
> when CONFIG_PCI_QUIRKS is not enabled.

Nice catch and thanks for the heads up.  My "[PATCH -v2 8/8] PCI:
Integrate 'pci_fixup_final' quirks into hot-plug paths" patch
introduced this - http://marc.info/?l=linux-pci&m=134187007917537&w=2

I'll handle it.

Thanks again,
 Myron

>
> --
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
