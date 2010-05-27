Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0E0WRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:17:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36571 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285Ab0E0WR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:17:29 -0400
Date: Thu, 27 May 2010 23:23:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527220949.GB10602@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 23:09:49 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 11:08:06PM +0100, Alan Cox wrote:
> 
> > This is I believe robust (and has been implemented on some non x86
> > boxes). It depends on not forcing running tasks into suspend. That is the
> > key.
> 
> We've already established that ACPI systems require us to force running 
> tasks into suspend. How do we avoid the race in that situation?

Android phones do not have ACPI. Embedded platforms do not have ACPI. MID
x86 devices do not have ACPI.

I would imagine the existing laptops will handle power management limited
by the functionality they have available. Just like any other piece of
hardware.

Alan
