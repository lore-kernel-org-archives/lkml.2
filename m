Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422630Ab2K1Xy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:54:29 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48173 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2K1XyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
 <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
 <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com>
 <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com>
 <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Nov 2012 16:54:03 -0700
Message-ID: <CAErSpo6h4sOmmanXBE3EHBDh2u4yNbpMcs6p05XG1nrO2rwvXg@mail.gmail.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        support@supermicro.com, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 6:49 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> It looks like maybe you don't have CONFIG_PCI_MMCONFIG turned on?
>
> ===> FOR I/OAT DMA
> Latest status, it _appears_ its working on the X9SRL-F now, thank you!
>
> 1) Supermicro X9SRL-F (GOOD)
> [    0.738510] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    0.738719] ioatdma 0000:00:04.0: irq 75 for MSI/MSI-X
> [    0.739088] ioatdma 0000:00:04.1: irq 76 for MSI/MSI-X
> [    0.739408] ioatdma 0000:00:04.2: irq 77 for MSI/MSI-X
> [    0.739739] ioatdma 0000:00:04.3: irq 78 for MSI/MSI-X
> [    0.740040] ioatdma 0000:00:04.4: irq 79 for MSI/MSI-X
> [    0.740342] ioatdma 0000:00:04.5: irq 80 for MSI/MSI-X
> [    0.740670] ioatdma 0000:00:04.6: irq 81 for MSI/MSI-X
> [    0.740971] ioatdma 0000:00:04.7: irq 82 for MSI/MSI-X

Good.  You have two issues, and I'm going to separate them and only
address the first one here.  I opened a bug report [1] against the
IOAT driver.  It should do something more useful when
CONFIG_PCI_MMCONFIG=n so we don't have to debug this again in the
future.  But otherwise, it sounds like this issue is resolved.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=51101
