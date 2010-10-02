Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0JBOP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:15:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60810 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755512Ab0JBOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:15:26 -0400
Date: Sat, 2 Oct 2010 10:15:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Runtime: Reduce code duplication in core helper
 functions (was: Re: [linux-pm] [PATCH] PM: add synchronous ...)
In-Reply-To: <201010020037.55277.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1010021012590.15874-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010, Rafael J. Wysocki wrote:

> > > > BTW, I like some changes made by your patch that aren't really related to
> > > > the issue at hand, so I think the patch below can be applied regardless of
> > > > the other changes, unless I made a mistake I can see now.
> > > 
> > > It looks like a good change, but you forgot to preserve the assignments 
> > > to dev->power.runtime_error.
> > 
> > That's correct and there's a difference betwee _idle and the other cases
> > because of that.  I'll send updated patch with a changelog shortly.
> 
> Appended as promised.

This looks okay.  In principle you could tell rpm_callback whether or 
not to store the return value in dev->power.runtime_error (by passing 
an extra argument), but it's probably not worthwhile.

Alan Stern

