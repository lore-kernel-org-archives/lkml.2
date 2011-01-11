Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1AKOeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:34:09 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932249Ab1AKOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:34:07 -0500
Date: Tue, 11 Jan 2011 15:34:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110111143406.GC22390@atrey.karlin.mff.cuni.cz>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <201101111211.30172.jeremy.kerr@canonical.com> <20110111090311.GM12078@pengutronix.de> <20110111092842.GJ12552@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111092842.GJ12552@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Another solution occurs to me: clk_enable() which returns -EAGAIN if
> it's called in an atomic context but needs to sleep, and let the driver
> deal with the clock not being enabled when it wants it.  The down side
> is it requires the driver to have additional code to sort out such a
> problem.

I do not think that "atomic context" is possible to reliably detect
inside a function like that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
