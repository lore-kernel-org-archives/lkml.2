Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1DTL5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:57:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40038 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1DTL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:57:52 -0400
Date: Wed, 20 Apr 2011 12:57:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-pm] [PATCH 7/9] PM / Runtime: Add generic clock
	manipulation rountines for runtime PM
Message-ID: <20110420115738.GA25571@sirena.org.uk>
References: <201104130205.26988.rjw@sisk.pl> <201104170142.10723.rjw@sisk.pl> <20110419105836.GG9462@sirena.org.uk> <201104192335.34560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104192335.34560.rjw@sisk.pl>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:35:34PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 19, 2011, Mark Brown wrote:

> > I've had similar thoughts with respect to the regulator API - I'd been
> > thinking of dealing with this by adding a notifier which subsystems
> > could build upon, in much the same way as already exists for the system
> > ssuspend and resume events.

> Well, I generally avoid using notifiers, because they lead to big functions
> that carry out many different tasks.

> That said, I think consolidation and reduction of duplicate code is all good,
> this way or another. :-)

Well, if you're comfortable with adding explicit regulator API hooks in
the code directly then I can just do that - I'd been thinking notifiers
since they mean you don't have to worry about what's going on with it
but if you're happy with making it explicit that's fine by me also.
