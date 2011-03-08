Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1CHG7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 01:59:03 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281Ab1CHG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 01:59:00 -0500
Date: Tue, 8 Mar 2011 07:58:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110308065845.GB1357@ucw.cz>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <201103042330.25079.rjw@sisk.pl>
 <20110305103444.GA26773@albatros>
 <201103051224.18621.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103051224.18621.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > > modules_disabled surely is not the right interface to disable hibernation
> > > and I don't really think there's a bug because it doesn't work as you'd like
> > > it to.  In fact, there would be a bug if it did work that way.
> > 
> > What do you mean here?  Do you agree that you may read kernel image,
> > slightly change it (including e.g. possible checksums, I didn't bother
> > to check how much one should change), and write it back?
> 
> Yes, you can, but that's not the point.  The point is that calling an interface
> that disables all possible functionality modifying kernel memory
> "modules_disabled" is completely dumb.  Sorry, but that's how it goes.

Fully agreed.

If you want a subset of cap_sys_admin than can't install
rootkit... just do it like that. Create cap_small_admin with such
subset and migrate people that don't need full admin to it.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
