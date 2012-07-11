Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2GKTUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:20:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39294 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab2GKTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:20:22 -0400
Date: Wed, 11 Jul 2012 12:20:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
Message-ID: <20120711192016.GA2857@kroah.com>
References: <201204292244.16467.rjw@sisk.pl>
 <201207111107.56500.rjw@sisk.pl>
 <20120711135333.GA19410@kroah.com>
 <201207112104.49173.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207112104.49173.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 09:04:48PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 11, 2012, Greg KH wrote:
> > On Wed, Jul 11, 2012 at 11:07:56AM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, July 11, 2012, Greg KH wrote:
> > > > On Sun, Apr 29, 2012 at 10:44:16PM +0200, Rafael J. Wysocki wrote:
> > > > > From: Oleksij Rempel <bug-track@fisher-privat.net>
> > > > > 
> > > > > This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
> > > > > more closely and fixes suspend bug found on ASUS Zenbook UX31E.
> > > > > 
> > > > > Some OEM use _SxD fileds do blacklist brocken Dx states.
> > > > > If _SxD/_SxW return values are check before suspend as appropriate,
> > > > > some nasty suspend/resume issues may be avoided.
> > > > > 
> > > > > References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
> > > > > Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > ---
> > > > > 
> > > > > Bjorn, Len,
> > > > > 
> > > > > This is -stable material and therefore v3.4 as well, IMO.  Please let me
> > > > > know if one of you can take it or whether you want me to handle it all the
> > > > > way to Linus.
> > > > 
> > > > What ever hapened to this patch?
> > > 
> > > It was split and partially merged.  As far as the other part is concerned,
> > > the jury is still out.
> > 
> > Ok, I'll wait for someone to ask for it to be added to the stable tree
> > before I do anything.
> 
> In fact, it should have been marked as -stable material, so please add:
> 
> commit dbe9a2edd17d843d80faf2b99f20a691c1853418
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Tue May 29 21:21:07 2012 +0200
> 
>     ACPI / PM: Make acpi_pm_device_sleep_state() follow the specification

Ah, the name changed, that's why I couldn't find it.  Thanks, I've now
queued it up.

greg k-h
