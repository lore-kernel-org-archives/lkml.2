Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0IEWPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 18:15:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47416 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753848Ab0IEWPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 18:15:39 -0400
Date: Sun, 5 Sep 2010 23:35:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kandziora <jjj@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: additional serial ports on MS9830 board do not work
 (IRQ problems)
Message-ID: <20100905233504.5000a308@lxorguk.ukuu.org.uk>
In-Reply-To: <201009052009.09743.jjj@gmx.de>
References: <201009052009.09743.jjj@gmx.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried the suggested option "irqpoll", but then the computer just freezes 
> when I do "od /dev/ttyS0" and touch the screen. No kernel panic, just a hard 
> freeze. I tried "acpi=noirq", "acpi=off" and disabling the APIC in the BIOS 
> setup, too. None of these made the serial irq work.

I suspect you need a BIOS which has correct tables for IRQ routing.

> Can you give me any useful pointers what to try next? Kernel configuration is 
> attached.

Vendor for BIOS update would be the obvious starting point.
