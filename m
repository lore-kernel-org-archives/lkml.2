Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0EaWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:44:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab0EaWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:44:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode and kernel API
Date: Tue, 1 Jun 2010 00:45:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mark.gross@intel.com, Alan Stern <stern@rowland.harvard.edu>
References: <20100530200409.GA21632@gvim.org> <20100531095753.4c174f2d@notabene.brown> <20100531221035.GB31155@gvim.org>
In-Reply-To: <20100531221035.GB31155@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006010045.21382.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010, mark gross wrote:
> On Mon, May 31, 2010 at 09:57:53AM +1000, Neil Brown wrote:
...
> > So I would suggest modifying your proposal to simply create a new 'input'
> > device.  Any driver that supports wake-from-suspend queues an event to that
> > device when a wakeup event occurs.  If the device is open and has any queued
> > events, then a suspend request such as 'echo mem > /sys/power/state' completes
> > without going into full suspend.
> 
> /me likes.
>  
> > Then you just need to convince us that this mechanism can be used without any
> > race problems.  If it can, then it would certainly be a simple and
> > unobtrusive approach.
> 
> Lets find out.

Simple question: how is that better than the Alan Stern's proposed approach?

Rafael
