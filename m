Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0FXPgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:36:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48448 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754920Ab0FXPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:36:00 -0400
Date: Thu, 24 Jun 2010 11:35:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006241706.45094.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006241132410.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Rafael J. Wysocki wrote:

> Ah, one piece is missing.  Namely, the waiting /sys/power/wakeup_count reader
> needs to be woken up when events_in_progress goes down to zero.

It also needs to abort immediately if a signal is received.

Alan Stern

