Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1BFPX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:23:57 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44080 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752959Ab1BFPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:23:56 -0500
Date: Sun, 6 Feb 2011 10:23:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Minchan Kim <minchan.kim@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] usb_set_device_state
In-Reply-To: <201102061408.27252.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102061022410.20379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:

> On Sunday, February 06, 2011, Minchan Kim wrote:

> > When I am googling, I found https://lkml.org/lkml/2011/1/14/440.
> > Maybe the bug is caused by that.
> > It is in linux-next and mmotm, not linus tree.
> 
> Yes, it is, thanks!
> 
> I'll revert the patch for now and see how it can be fixed.

Sorry, I didn't mention this because I thought it was obvious.  Before 
that patch, device_set_wakeup_capable() was a simple assignment that 
could run in any context.  After the patch it requires process context.

Alan Stern

