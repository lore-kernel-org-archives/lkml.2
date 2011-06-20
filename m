Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1FTSjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:39:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43837 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755248Ab1FTSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:39:04 -0400
Date: Mon, 20 Jun 2011 14:39:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Holler <holler@ahsoftware.de>
cc: Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <4DFF85D6.1090104@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Alexander Holler wrote:

> I see it that way: packed is needed to be sure that at least for struct 
> ehci_regs there are no padding bytes inbetween the members.

But is it _really_ needed?

> It might 
> work without, but that depends on the compiler (-version, architecture, 
> whatever).

Have there _ever_ been _any_ combinations of compiler, version, 
architecture, whatever, that had unwanted padding bytes in this 
structure?

Alan Stern

