Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2KBTSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:18:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62565 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2KBTSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121102180458.GA12052@srcf.ucam.org>
References: <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<20121101202701.GB20817@xo-6d-61-c0.localdomain>
	<5092E361.7080901@genband.com>
	<20121102163302.GA6080@elf.ucw.cz>
	<1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
	<20121102165456.GB9997@srcf.ucam.org>
	<1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	<20121102175416.GA11816@srcf.ucam.org>
	<1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	<20121102180458.GA12052@srcf.ucam.org>
Date: Fri, 2 Nov 2012 15:18:06 -0400
Message-ID: <CACLa4psWr4xW0xrJq11q9zQM5V=8-HhQxGf6kzRRkpeEM0iS3A@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know I started it, but Windows really isn't necessary to see value,
even if it is what pushed the timing.

A user installs a package as root.  Absent any flaws in the Linux
kernel (cough) that should be all it can do in a Secure Boot world.
But if you can drop a small trusted Linux system in there and use that
to boot a compromised Linux kernel, it can make itself persistent.

And like I said, I know there are cloud providers out there who want
EXACTLY this type of system.  One in which root in the guest is
untrusted and they want to keep them out of ring 0.
