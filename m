Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GQSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:25:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:50285 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2GQSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:25:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Galen Seitz <galens@seitzassoc.com>
Subject: Re: PCI ACPI/IRQ-routing broken on H77 chipset + Ivy Bridge (kernel 3.5-rc7 and earlier)
Date: Tue, 17 Jul 2012 18:01:32 +0000 (UTC)
Message-ID: <loom.20120717T195910-7@post.gmane.org>
References: <5002BC55.3050107@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 216.99.217.243 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:13.0) Gecko/20100101 Firefox/13.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malte Schröder <maltesch <at> gmx.de> writes:
> 
> Hello,
> this is yet another try to get someone to look at this ;)
> 
> I can't get PCI-devices to work on my DH77KC mainboard. I tested this
> using an AVM B1 ISDN card, a Fritz!PCI card and an old 3Com 905c NIC.
> I attached some dumps in case it helps. The CPU is a Core i7 3770.
> 
> PCI hardware is detected by the kernel, but it gives IRQ errors. Using
> irqpoll allows the PCI card to somewhat work, but it is unreliable.
> 
> There are some reports in Intel's support forums that also report
> PCI-problems with this mainboard, but Intel doesn't seem to be
> interested. So I hope this is something that is fixable on the kernel side.
> 
> If there is more information needed, please let me know.
> 

I was having similar problems with my DH77KC.  I discovered that the
BIOS interrupt routing tables for the conventional PCI slots are incorrect.
See the discussion here:
https://bugzilla.kernel.org/show_bug.cgi?id=43238

Galen Seitz




