Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2GSSOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:14:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60113 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751571Ab2GSSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:14:44 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/gs2smGe3gs8MW2bomZFwqPca+P/JmB11TbzTxFK
	l2iA7FCDoSRbz1
Message-ID: <50084E8B.3070508@gmx.de>
Date: Thu, 19 Jul 2012 20:14:35 +0200
From: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Galen Seitz <galens@seitzassoc.com>
Subject: Re: PCI ACPI/IRQ-routing broken on H77 chipset + Ivy Bridge (kernel
 3.5-rc7 and earlier)
References: <5002BC55.3050107@gmx.de> <201207152225.49154.rjw@sisk.pl> <CAErSpo6Ka6XBakVZH7ge-==XY86FrOHP_dqGoa+zAFNgnnnFTA@mail.gmail.com>
In-Reply-To: <CAErSpo6Ka6XBakVZH7ge-==XY86FrOHP_dqGoa+zAFNgnnnFTA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2012 18:14, Bjorn Helgaas wrote:

> [CC +tglx]
> 
> On Sun, Jul 15, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> CC-ing linux-pci and Bjorn.
>>
>> On Sunday, July 15, 2012, Malte Schröder wrote:
>>> Hello,
>>> this is yet another try to get someone to look at this ;)
>>>
>>> I can't get PCI-devices to work on my DH77KC mainboard. I tested this
>>> using an AVM B1 ISDN card, a Fritz!PCI card and an old 3Com 905c NIC.
>>> I attached some dumps in case it helps. The CPU is a Core i7 3770.
>>>
>>> PCI hardware is detected by the kernel, but it gives IRQ errors. Using
>>> irqpoll allows the PCI card to somewhat work, but it is unreliable.
>>>
>>> There are some reports in Intel's support forums that also report
>>> PCI-problems with this mainboard, but Intel doesn't seem to be
>>> interested. So I hope this is something that is fixable on the kernel side.
>>>
>>> If there is more information needed, please let me know.
>>>


I was pointed to https://bugzilla.kernel.org/show_bug.cgi?id=43238.
I tried the modifications to the DSDT that where proposed there and
voilà, the 3c905c started to work :)
So it seems Intel messed up their ACPI-stuff really bad for this
mainboard. I plan to do more testing during the weekend.

-- 
Gruß
Malte Schröder
---------------------------------------------------------------------
MalteSch@gmx.de
