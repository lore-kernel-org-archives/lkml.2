Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2FQM71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 08:59:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42809 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757220Ab2FQM7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 08:59:25 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1+I9hd4xhiIXpWOtbEnVF7JPEPnpS9RzNv4fImvZW
	KYlCf76WYzn1lz
Message-ID: <4FDDD4AA.4000903@gmx.de>
Date: Sun, 17 Jun 2012 14:59:22 +0200
From: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI problems with Intel H77 chipset, kernel 3.4 and 3.5-rc3 (was
 AVM B1 PCI on DH77KC (H77 chipset) problem, requires pci=noirq)
References: <4FD7A90F.7070900@gmx.de>
In-Reply-To: <4FD7A90F.7070900@gmx.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did further tests, none successful.

On 12.06.2012 22:39, Malte Schröder wrote:

> Hello,
> I am trying to get an old and trusty active ISDN-card to work on a shiny
> new Intel DH77KC mainboard in conjunction with an i7 Ivy Bridge
> processor. (it's supposed to bridge VoIP to ISDN, amongst other stuff).

Since my original report I moved the new system into a test-box.

> 
> When booting "normally", the card is recognized by the kernel. But then
> the firmware upload fails. I can get this to work when using irqfixup or
> irqpoll.

I now tried to get a 3Com NIC (3c905c) to work on the PCI-bus. That
doesn't work either. I get those "nobody cared" IRQ-messages.
I also updated the BIOS.
There seems to be something wrong WRT ACPI irq routing.

What further data should I provide to get this solved?

-- 
Gruß
Malte Schröder
---------------------------------------------------------------------
MalteSch@gmx.de
