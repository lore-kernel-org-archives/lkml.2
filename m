Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0FBMCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:02:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56602 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754865Ab0FBMCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:02:21 -0400
Date: Wed, 2 Jun 2010 13:08:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
 pci_reboot_dmi_table.
Message-ID: <20100602130827.12c28744@lxorguk.ukuu.org.uk>
In-Reply-To: <20100601214820.GB18864@srcf.ucam.org>
References: <20100601200704.GA16091@srcf.ucam.org>
	<4C056AE6.3000409@gmail.com>
	<20100601202130.GA16391@srcf.ucam.org>
	<4C056E0C.2030709@gmail.com>
	<20100601203351.GA16575@srcf.ucam.org>
	<4C0572B4.6000201@gmail.com>
	<20100601211219.GA17719@srcf.ucam.org>
	<4C057AE9.9020307@gmail.com>
	<20100601212901.GA18390@srcf.ucam.org>
	<4C057EF0.2030808@gmail.com>
	<20100601214820.GB18864@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 22:48:20 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Tue, Jun 01, 2010 at 02:43:12PM -0700, Justin P. Mattock wrote:
> > On 06/01/2010 02:29 PM, Matthew Garrett wrote:
> >> So, just to be clear, you run this as root and it immediately returns
> >> you to the prompt? This seems unlikely.
> >
> > yep.. with the above code
> > I (save to a file) then
> > non-root gcc reboot.c -o reboot
> > then su
> > ./reboot
> > just bake to the command prompt
> 
> Are you running some sort of security policy that might block hardware 
> access?

	Try

	if (iopl(...))
		perror

... (or strace it running as root)
