Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1DHQcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:32:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757020Ab1DHQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:32:15 -0400
Date: Fri, 8 Apr 2011 12:32:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless loop with "detected XactErr"
In-Reply-To: <BANLkTikaa+jgjuckXan8d-JVDDdUhO_JDw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081230230.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Zdenek Kabelac wrote:

> > You might want to track down the original source of the
> > underlying error.  Since the machine was docked the entire time, the
> > line saying:
> >
> > [ �473.873802] ACPI: \_SB_.GDCK - undocking
> >
> > definitely looks suspicious.  I bet if you can fix that then the USB
> > problems will go away.
> 
> Hmm looking now into more logs - it might have been used this:
> 
> "echo 1 >/sys/devices/platform/dock.0/undock"
> 
> for this particular testcase  - I might have been checking several
> combination and making modification of some pm script for this.
> So yes - in this case the machine could have been undocked by the above command.
> 
> Is that a major problem for USB ?

Not normally, but maybe the software undock didn't work correctly.

Or maybe it did work.  What happens if you disable CONFIG_USB_DEBUG?

Alan Stern

