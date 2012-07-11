Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2GKJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:02:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2GKJCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:02:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
Date: Wed, 11 Jul 2012 11:07:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>
References: <201204292244.16467.rjw@sisk.pl> <20120711000850.GD18128@kroah.com>
In-Reply-To: <20120711000850.GD18128@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111107.56500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 11, 2012, Greg KH wrote:
> On Sun, Apr 29, 2012 at 10:44:16PM +0200, Rafael J. Wysocki wrote:
> > From: Oleksij Rempel <bug-track@fisher-privat.net>
> > 
> > This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
> > more closely and fixes suspend bug found on ASUS Zenbook UX31E.
> > 
> > Some OEM use _SxD fileds do blacklist brocken Dx states.
> > If _SxD/_SxW return values are check before suspend as appropriate,
> > some nasty suspend/resume issues may be avoided.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
> > Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > Bjorn, Len,
> > 
> > This is -stable material and therefore v3.4 as well, IMO.  Please let me
> > know if one of you can take it or whether you want me to handle it all the
> > way to Linus.
> 
> What ever hapened to this patch?

It was split and partially merged.  As far as the other part is concerned,
the jury is still out.

Thanks,
Rafael
