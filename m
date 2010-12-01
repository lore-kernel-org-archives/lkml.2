Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0LAPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:15:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38711 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753385Ab0LAPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:15:57 -0500
Date: Wed, 1 Dec 2010 10:15:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors
 unnecessarily
In-Reply-To: <201011302327.24222.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012011013500.1629-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Rafael J. Wysocki wrote:

> > Provided you repair the error that Lei Ming pointed out.  That's the 
> > problem with functions that return Boolean values -- you have to name 
> > them very carefully.  Ideally the name should be a predicate or a
> > question.
> 
> I already have fixed it.
> 
> The name is unfortunate indeed, perhaps it's better to call that function
> pm_new_wakeup_events() or something like this.

Or pm_any_wakeup_events().  And reverse the meaning of the return
value, of course -- it would be good to explain the return value in 
the kerneldoc.

Alan Stern

