Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1FFMQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:16:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50853 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1FFMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:16:09 -0400
Date: Mon, 6 Jun 2011 13:16:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: 3.0-rc1: alsactl restore fails on spitz
Message-ID: <20110606121603.GB30378@sirena.org.uk>
References: <20110602031455.GC1565@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602031455.GC1565@ucw.cz>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 05:14:55AM +0200, Pavel Machek wrote:

> Something changed in ALSA land, if you use sound you may want to check.

You've not included even the most basic diagnostic information in your
report.  I'd expect this is user error of some kind but "fails" isn't
the most verbose report...
