Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab0E0Rll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:41:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41304 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759359Ab0E0Rlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:41:39 -0400
Date: Thu, 27 May 2010 13:41:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Felipe Balbi <felipe.balbi@nokia.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <alpine.LFD.2.00.1005271924170.3032@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1005271340030.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Thomas Gleixner wrote:

> > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> 
> mem should be replaced by an idle suspend to ram mechanism

In other words, you are suggesting that not only should the Android
patches not be accepted, in addition a large part of the PM suspend
framework should be rewritten?

Alan Stern

