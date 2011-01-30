Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1A3Wm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 17:42:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1A3Wmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 17:42:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
Date: Sun, 30 Jan 2011 23:42:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <4D41EA12.1030402@free.fr> <201101292215.57292.rjw@sisk.pl> <20110130210441.150e1006@mat-laptop>
In-Reply-To: <20110130210441.150e1006@mat-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101302342.40977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 30, 2011, matthieu castet wrote:
> Le Sat, 29 Jan 2011 22:15:57 +0100,
> "Rafael J. Wysocki" <rjw@sisk.pl> a écrit :
> 
> > On Saturday, January 29, 2011, matthieu castet wrote:
> > > Rafael J. Wysocki a écrit :
> > > > 
> > > > It _looks_ sane, but it will require some serious testing.  I'm
> > > > not sure, though, if we can get enough testing coverage without
> > > > actually committing that change.
> > > > 
> > > > How much testing has it received so far?
> > > > 
> > > Not too much only qemu with 1 and 2 core and a laptop with 1 cpu.
> > > 
> > > Please note that with this patch we can also remove the gdt, idt,
> > > ldt stuff from arch/x86/kernel/acpi/wakeup_32.S
> > 
> > That's correct, but those changes can wait. 
> Any idea how to test this patch with more configurations ?
> 
> Submitting it to tip ? 
> But as resume regression showed, there aren't many user with 32 bits
> system using it.

No, I don't think there are too many users testing suspend with -tip on x86-32.
I'm afraid the changes in question won't get any substantial testing until
included into the mainline, but it will be easier to diagnose problems with
them if they go in during the .39 merge window.

Thanks,
Rafael
