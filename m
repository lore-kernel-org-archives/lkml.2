Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0E1A7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:59:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44901 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757331Ab0E1A70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:59:26 -0400
Date: Thu, 27 May 2010 20:59:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <201005280124.25347.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005272057500.31050-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Rafael J. Wysocki wrote:

> > And the forced-suspend design relies on the fact that processes remain 
> > frozen throughout.  If we leave some processes unfrozen and one of them 
> > somehow becomes runnable, that means we have to abort the forced 
> > suspend before the process is allowed to run.
> 
> We could avoid that if drivers could block tasks, but there are questions to
> answer.  First off, how a driver is supposed to know when to block the task
> using it and when to do its power management transparently for the task?
> Second, how to intercept and block all possible interfaces that user space
> can use to talk to drivers (how to intercept a task using mmapped device, for
> example)?

We talked about this a few years ago and decided it was not feasible.  
It would require substantial changes to every device driver.

Alan Stern

