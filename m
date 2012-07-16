Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2GPQPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:15:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44632 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2GPQPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <201207152225.49154.rjw@sisk.pl>
References: <5002BC55.3050107@gmx.de> <201207152225.49154.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Jul 2012 10:14:56 -0600
Message-ID: <CAErSpo6Ka6XBakVZH7ge-==XY86FrOHP_dqGoa+zAFNgnnnFTA@mail.gmail.com>
Subject: Re: PCI ACPI/IRQ-routing broken on H77 chipset + Ivy Bridge (kernel
 3.5-rc7 and earlier)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC +tglx]

On Sun, Jul 15, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> CC-ing linux-pci and Bjorn.
>
> On Sunday, July 15, 2012, Malte Schröder wrote:
>> Hello,
>> this is yet another try to get someone to look at this ;)
>>
>> I can't get PCI-devices to work on my DH77KC mainboard. I tested this
>> using an AVM B1 ISDN card, a Fritz!PCI card and an old 3Com 905c NIC.
>> I attached some dumps in case it helps. The CPU is a Core i7 3770.
>>
>> PCI hardware is detected by the kernel, but it gives IRQ errors. Using
>> irqpoll allows the PCI card to somewhat work, but it is unreliable.
>>
>> There are some reports in Intel's support forums that also report
>> PCI-problems with this mainboard, but Intel doesn't seem to be
>> interested. So I hope this is something that is fixable on the kernel side.
>>
>> If there is more information needed, please let me know.
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
