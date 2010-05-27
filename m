Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0E0R3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:29:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39422 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758109Ab0E0R3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:29:19 -0400
Date: Thu, 27 May 2010 13:29:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1274980420.27810.5557.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Peter Zijlstra wrote:

> On Thu, 2010-05-27 at 13:04 -0400, Alan Stern wrote:
> > 
> > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> > attention to latencies or other requirements. 
> 
> Those are a whole different beast, those are basically a quick-off
> button like thing. Forced suspend is conceptually a very different beast
> from power-saving a running system.

They may be different conceptually.  Nevertheless, Android uses forced 
suspend as a form of power saving.  Until better mechanisms are in 
place, it makes sense.

Alan Stern

