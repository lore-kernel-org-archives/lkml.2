Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0KOPUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:20:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35725 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755882Ab0KOPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:20:22 -0500
Date: Mon, 15 Nov 2010 10:20:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
In-Reply-To: <201011102151.22552.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1011151018380.1606-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Rafael J. Wysocki wrote:

> What about applying the patch below now and moving to the multiple list heads
> approach in the next cycle?
> 
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Allow devices to be removed during late suspend and early resume
> 
> Holding dpm_list_mtx across late suspend and early resume of devices
> is problematic for the PCMCIA subsystem and doesn't allow device
> objects to be removed by late suspend and early resume driver
> callbacks.  This appears to be overly restrictive, as drivers are
> generally allowed to remove device objects in other phases of suspend
> and resume.  Therefore rework dpm_{suspend|resume}_noirq() so that
> they don't have to hold dpm_list_mtx all the time.

This looks okay to me.  Just like the other routines.

Alan Stern

