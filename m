Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0FBLvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:51:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44316 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078Ab0FBLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:51:36 -0400
Date: Wed, 2 Jun 2010 12:58:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100602125811.4ae414e2@lxorguk.ukuu.org.uk>
In-Reply-To: <1275469851.27810.30775.camel@twins>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<1275469851.27810.30775.camel@twins>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 11:10:51 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-06-02 at 10:29 +0200, Thomas Gleixner wrote:
> 
> 
> > If I understood you correctly then you can shutdown the CPU in idle
> > completelty already, but that's not enough due to:
> > 
> >     1) crappy applications keeping the cpu away from idle
> >     2) timers firing
> > 
> > Would solving those two issues be sufficient for you or am I missing
> > something ?
> 
> Aren't the container snapshot/resume people fighting the same set of
> problems here?

And virtualisation - its a big one for virtualisation because if you've
got 1000 misbehaving guests generating 100 wakeups a second you've got a
problem ....

Alan
