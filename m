Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1A3UEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 15:04:53 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:57741 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1A3UEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 15:04:51 -0500
Date: Sun, 30 Jan 2011 21:04:41 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
Message-ID: <20110130210441.150e1006@mat-laptop>
In-Reply-To: <201101292215.57292.rjw@sisk.pl>
References: <4D41EA12.1030402@free.fr>
	<201101272354.00042.rjw@sisk.pl>
	<4D447C00.70709@free.fr>
	<201101292215.57292.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 29 Jan 2011 22:15:57 +0100,
"Rafael J. Wysocki" <rjw@sisk.pl> a écrit :

> On Saturday, January 29, 2011, matthieu castet wrote:
> > Rafael J. Wysocki a écrit :
> > > 
> > > It _looks_ sane, but it will require some serious testing.  I'm
> > > not sure, though, if we can get enough testing coverage without
> > > actually committing that change.
> > > 
> > > How much testing has it received so far?
> > > 
> > Not too much only qemu with 1 and 2 core and a laptop with 1 cpu.
> > 
> > Please note that with this patch we can also remove the gdt, idt,
> > ldt stuff from arch/x86/kernel/acpi/wakeup_32.S
> 
> That's correct, but those changes can wait. 
Any idea how to test this patch with more configurations ?

Submitting it to tip ? 
But as resume regression showed, there aren't many user with 32 bits
system using it.


Matthieu
