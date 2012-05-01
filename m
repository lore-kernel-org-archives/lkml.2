Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2EAQ7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:59:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34279 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756169Ab2EAQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:59:35 -0400
Date: Tue, 1 May 2012 12:59:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
In-Reply-To: <4FA00EE5.2060403@fisher-privat.net>
Message-ID: <Pine.LNX.4.44L0.1205011258180.1499-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Oleksij Rempel (fishor) wrote:

> > There also remains a question about runtime power states and resume.
> >
> > Oleksij, with your patch, which state does the controller get put into
> > during runtime suspend, D2 or D3?  (You may need to enable runtime
> > suspend by doing
> >
> > 	echo auto>/sys/bus/pci/devices/0000:00:1d.0/power/control
> >
> > in order to test this.)  And if the controller is in runtime suspend,
> > does it resume correctly when you plug in a new USB device?
> >
> > I'm pretty sure that without the patch, the controller gets put into D3
> > and resume does work.
> 
> I do not know if device really suspended, but every thing works like 
> before. New usb devices are recognized and working.

You ought to be able to tell the controller's state by looking at the
dmesg log (after doing the "echo" command above) or the output from
lspci -v.

Alan Stern

