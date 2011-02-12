Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BLTwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:52:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61099 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1BLTwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:52:40 -0500
Date: Sat, 12 Feb 2011 14:52:34 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dave Martin <dave.martin@linaro.org>, Sachin Verma <imschnvrm@gmail.com>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: ARM: relocation out of range (when loading a module)
In-Reply-To: <20110211144207.GJ23404@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1102121435470.14920@xanadu.home>
References: <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101121350350.25498@xanadu.home> <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com> <alpine.LFD.2.00.1101270030220.8580@xanadu.home>
 <20110210154322.GE1742@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1102101405010.14920@xanadu.home> <AANLkTi=KtFf5BU-iH-sUUL=Q30S90bk608JR4zFz2CKf@mail.gmail.com> <alpine.LFD.2.00.1102110838430.14920@xanadu.home> <AANLkTimW9zQ3EcEo8+gcxnS72Wa9VZELvrqdY+jP0B7W@mail.gmail.com>
 <20110211144207.GJ23404@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Russell King - ARM Linux wrote:

> On Fri, Feb 11, 2011 at 02:25:28PM +0000, Dave Martin wrote:
> >  if we can also move the initramfs somewhere less obstructive in the
> > future, then so much the better.
> 
> This may do it, and it might even work.  Not particularly well tested
> yet.  It'd be loads easier if we didn't have to worry about XIP.

Is anyone actually still using XIP these days?  Now that NOR flash is 
not that much used anymore, if maintaining XIP support is more trouble 
than it is worth we could simply deprecate it.  The linker script has 
become quite more hairy than it used to be, and from a quick look I'm 
not even sure if all the stuff in there is properly located for XIP.

Otherwise, for the __init stuff move:

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>


Nicolas
