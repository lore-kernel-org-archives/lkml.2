Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1GKWRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:17:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35486 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1GKWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:17:33 -0400
Date: Mon, 11 Jul 2011 18:17:30 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
cc: Kevin Hilman <khilman@ti.com>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Please submit platform trees for inclusion in arm-soc.git v3.1
In-Reply-To: <201107112337.08892.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1107111815340.14596@xanadu.home>
References: <201107012018.14619.arnd@arndb.de> <87wrfsahez.fsf@ti.com> <201107112337.08892.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Arnd Bergmann wrote:

> On Friday 08 July 2011, Kevin Hilman wrote:
> > > Time is running out for the current cycle, so any changes that you
> > > want to see merged in linux-3.1 through the arm-soc tree should be
> > > submitted in form of pull-requests very soon.
> > 
> > [...]
> > 
> > It looks like your "remove rmk/for-next" commit may not have been
> > totally complete.
> > 
> > Trying to merge your master branch and Russell's current for-next branch
> > still results in conflicts in files that should only be touched in
> > Russell's branch (specifically, these seem related to changes in
> > Russell's 'suspend' branch that is included in his 'for-next' branch.)
> 
> Yes, that's my fault for not fixing this up correctly after initially
> doing the incorrect pull.
> 
> I guess I'll throw away the current master branch and generate a new
> one. After discussing this with Russell, I think it's best to treat
> the master branch as temporary anyway unless Nicolas or Thomas come up
> with a good reason against doing this.

No objections.  However, to avoid confusion, I'd suggest getting rid of 
the branch called "master" entirely and call it something else.


Nicolas
