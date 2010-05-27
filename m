Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab0E0VyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:54:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab0E0VyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:54:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Thu, 27 May 2010 23:55:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <20100527140655.GA28048@srcf.ucam.org> <20100527182058.GL3543@srcf.ucam.org> <20100527200950.44305cef@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527200950.44305cef@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272355.13222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Alan Cox wrote:
> > > If one works so does the other.
> > 
> > Not at all. The entire point of opportunistic suspend is that I don't 
> > care is currently in TASK_RUNNABLE or has a timer that's due to expire 
> > in 100msec - based on policy (through not having any held suspend 
> > blockers), I'll go to sleep. That's easily possible on PCs.
> 
> Yes I appreciate what suspend blockers are trying to do. Now how does
> that connect with my first sentence ?

I guess what Matthew wanted to say was that you couldn't use ACPI S3 as
a very deep CPU idle state, because of the way wakeup sources are set up
for it, while you could use it for aggressive power management with suspend
blockers as proposed by Arve.

Rafael
