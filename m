Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1AYC4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:56:13 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:41137 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1AYC4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:56:10 -0500
Date: Mon, 24 Jan 2011 21:56:02 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
In-reply-to: <4D3DDDA4.2080202@yahoo.fr>
Message-id: <alpine.LFD.2.02.1101242154090.6097@x980>
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com>
 <4D3DDDA4.2080202@yahoo.fr>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> * 2.6.35 series: .4 and .6 boot successfully, .8 and .10 fail;
> >>> * 2.6.36 series: -rc2 boots successfully, .1 fails;
> >>> * 2.6.37 series: -rc4 fails.
> >>
> >> So it's probably a commit to the mainline tree which was picked
> >> by 2.6.35 maintainer to the stable tree (probably it was CC'ed)
> >> cause this.
> >>
> >> Does passing nolapic or acpi=off cures the issue?
> > IIRC, I tested at least one of these, without improvement.
> > I'll test again tonight, when I can physically access the
> > computer.
> None of nolapic, acpi=off, nolapic acpi=off enables 2.6.35.8 to boot
> on my ASUS F3Jv-AS022P.
> The kernel line is
> kernel /boot/vmlinuz root=/dev/sda9 nomce vga=791 nomodeset
> I've attached the 2.6.35.6 config.

looks like you've bisected as far as:
2.6.35.6 good
2.6.35.8 bad

can you try 2.6.35.7 and continue on to find which specific patch
in .stable broke your machine?

thanks,
Len Brown, Intel Open Source Technology Center

