Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2K2Asy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:48:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41238 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab2K2Asw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:48:52 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Robert Hancock'" <hancockrwd@gmail.com>
Cc: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com> <CAErSpo6h4sOmmanXBE3EHBDh2u4yNbpMcs6p05XG1nrO2rwvXg@mail.gmail.com>
In-Reply-To: <CAErSpo6h4sOmmanXBE3EHBDh2u4yNbpMcs6p05XG1nrO2rwvXg@mail.gmail.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Wed, 28 Nov 2012 19:48:50 -0500
Message-ID: <04b101cdcdcb$4cd6c090$e68441b0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xoByREOOQK10CNCAQcgOtyXQiBr4A==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Wednesday, November 28, 2012 6:54 PM
To: Justin Piszcz
Cc: Bruno Prémont; support@supermicro.com; linux-kernel@vger.kernel.org; Dan
Williams
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
bug question

On Tue, Nov 27, 2012 at 6:49 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
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

--

Yes--(agree w/ config option) Thank you!

Justin.

