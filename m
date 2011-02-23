Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1BWP7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:59:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42374 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754456Ab1BWP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:59:32 -0500
Date: Wed, 23 Feb 2011 10:59:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: "Rafael J. Wysocki" <rjw@suse.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
In-Reply-To: <4D64F678.10309@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1102231058240.2233-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Jiri Slaby wrote:

> On 02/22/2011 04:36 PM, Alan Stern wrote:
> > By the way, are you booting with no_console_suspend?  And do you do 
> > "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> > suspending?
> 
> Nope.

If you do, it's possible you might get some useful information on the 
screen the next time one of these hangs occurs.

Alan Stern

