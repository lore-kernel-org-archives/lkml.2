Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1DSVfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:35:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab1DSVfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:35:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [linux-pm] [PATCH 7/9] PM / Runtime: Add generic clock manipulation rountines for runtime PM
Date: Tue, 19 Apr 2011 23:35:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <201104130205.26988.rjw@sisk.pl> <201104170142.10723.rjw@sisk.pl> <20110419105836.GG9462@sirena.org.uk>
In-Reply-To: <20110419105836.GG9462@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192335.34560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 19, 2011, Mark Brown wrote:
> On Sun, Apr 17, 2011 at 01:42:10AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Many different platforms and subsystems may want to disable device
> > clocks during suspend and enable them during resume which is going to
> > be done in a very similar way in all those cases.  For this reason,
> > provide generic routines for the manipulation of device clocks during
> > suspend and resume.
> 
> > Convert the ARM shmobile platform to using the new routines.
> 
> I've had similar thoughts with respect to the regulator API - I'd been
> thinking of dealing with this by adding a notifier which subsystems
> could build upon, in much the same way as already exists for the system
> ssuspend and resume events.

Well, I generally avoid using notifiers, because they lead to big functions
that carry out many different tasks.

That said, I think consolidation and reduction of duplicate code is all good,
this way or another. :-)

Thanks,
Rafael
