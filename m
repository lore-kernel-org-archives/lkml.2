Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1AELXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:23:15 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57470 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751560Ab1AELXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:23:14 -0500
Date: Wed, 5 Jan 2011 12:23:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, mingo@elte.hu, trenn@suse.de,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 1/3] perf: add calls to suspend trace point
Message-ID: <20110105112313.GA18546@atrey.karlin.mff.cuni.cz>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com> <201101050001.23979.rjw@sisk.pl> <AANLkTimRvZs2QBZ4y+AEO7CWUudwBSM6-K0ZQxFTF+Fm@mail.gmail.com> <201101051115.55528.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101051115.55528.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> I am in favor of 3) of 4).
> > >> What do you think?
> > >
> > > Why don't we keep the tracepoints as proposed _and_ add two additional
> > > tracepoints around device suspend-resume?
> > I like the idea but that requires to extend the current API with
> > additional suspend tracepoints or device state change tracepoints.
> > That can be done once the current API is firmly in place.
> > Today the only trace API for suspend is machine_suspend(unsigned int
> > state), so I think the best option is 3) here above.
> > 
> > Unless there is an objection I am pushing 3) asap.
> 
> Fine by me.

Why not...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
