Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1DSK6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:58:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54608 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DSK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:58:49 -0400
Date: Tue, 19 Apr 2011 11:58:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-pm] [PATCH 7/9] PM / Runtime: Add generic clock
	manipulation rountines for runtime PM
Message-ID: <20110419105836.GG9462@sirena.org.uk>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl> <201104170142.10723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104170142.10723.rjw@sisk.pl>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 01:42:10AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Many different platforms and subsystems may want to disable device
> clocks during suspend and enable them during resume which is going to
> be done in a very similar way in all those cases.  For this reason,
> provide generic routines for the manipulation of device clocks during
> suspend and resume.

> Convert the ARM shmobile platform to using the new routines.

I've had similar thoughts with respect to the regulator API - I'd been
thinking of dealing with this by adding a notifier which subsystems
could build upon, in much the same way as already exists for the system
ssuspend and resume events.
