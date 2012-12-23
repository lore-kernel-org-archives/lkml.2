Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2LWL5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:57:04 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63791 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2LWL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:57:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAKGA1bnzYWG5POJ228ytayXztoXcMXt2rB-4S6fnrv5Gxo_=TQ@mail.gmail.com>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
	<1343843371-14143-5-git-send-email-matt@genesi-usa.com>
	<CAOMZO5CcUZ8NKM6uHkBB1Yo9MjeoBq9NzpOYwT1squM4TOgV7g@mail.gmail.com>
	<CAKGA1bnzYWG5POJ228ytayXztoXcMXt2rB-4S6fnrv5Gxo_=TQ@mail.gmail.com>
Date: Sun, 23 Dec 2012 09:48:57 -0200
Message-ID: <CAOMZO5DDV5HVF+WNd8gUmwpfmxiFQcjWBWkNfNT1cdpHLCoVGg@mail.gmail.com>
Subject: Re: [PATCH 4/4] efikamx: remove Efika MX-specific CHRGVBUS hack from
 the USB driver
From: Fabio Estevam <festevam@gmail.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 8:42 AM, Matt Sealey <matt@genesi-usa.com> wrote:
> Anyone got a clue who the actual USB maintainer is who cares about ehci-mxc?

$ ./scripts/get_maintainer.pl -F drivers/usb/host/ehci-mxc.c
Alan Stern <stern@rowland.harvard.edu> (maintainer:USB EHCI DRIVER)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBSYSTEM)
linux-usb@vger.kernel.org (open list:USB EHCI DRIVER)
linux-kernel@vger.kernel.org (open list)

> Best search through the maintainers file is Li Yang <leoli@freescale.com>
> and of course I could always nudge David Brownell, Sascha (your name is at
> the top of the file!)
>
> I was going to resubmit on Friday and push an alternative patch to the
> chipidea driver but I can't figure out who's in control, if the only nitpick
> is I didn't CC the right people then this could take many, many submissions
> while this gets figured out :D

$ ./scripts/get_maintainer.pl -F drivers/usb/chipidea/host.c
Alexander Shishkin <alexander.shishkin@linux.intel.com>
(maintainer:CHIPIDEA USB HIGH...)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBSYSTEM)
linux-usb@vger.kernel.org (open list:CHIPIDEA USB HIGH...)
linux-kernel@vger.kernel.org (open list)

Regards,

Fabio Estevam
