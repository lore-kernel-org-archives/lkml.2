Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1LEQKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:10:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35808 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932447Ab1LEQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:10:37 -0500
Date: Mon, 5 Dec 2011 11:10:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Subject: Re: [RFC] UASP on target (was: [RFC/PATCH v4 1/3] uas: MS UAS Gadget
 driver - Infrastructure)
In-Reply-To: <20111205082326.GA2734@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1112051109040.5138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Sebastian Andrzej Siewior wrote:

> * Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
> 
> >* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
> >
> >>This patch implements the infrastructure for the UAS gadget driver.
> >>The UAS gadget driver registers as a second configuration of the MS
> >>gadet driver.
> >hch said to use target framework and you haven't done so. This is what I
> >have so far. It is not yet complete. What I need to do is:
> >- wire up command processing (currently here)
> >- wire up data processing
> >- check it works => post v1
> >- wire up command tagging => v2
> >- remove hard codings and fix whatever people complained about.

Evidently you were able to find enough information about the target 
framework to write a driver using it.  Can you tell us where this 
information is?  It hasn't been easy to locate.

Alan Stern

