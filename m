Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0E2OQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:16:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49181 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752162Ab0E2OQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:16:03 -0400
Date: Sat, 29 May 2010 10:16:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275120618.27810.12699.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005291013110.30763-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, Peter Zijlstra wrote:

> Correct, I strongly oppose using suspend. Not running runnable tasks is
> not a sane solution.
> 
> If current hardware can't cope, too friggin bad, get better hardware.

Taken out of context, this statement suggests you believe that
x86-based laptops should not be allowed to suspend automatically when
their lids are closed, and that everybody should replace their
x86-based laptops with something better.

Is that really what you mean?

Alan Stern

