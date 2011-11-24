Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1KXKhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:37:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43488 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1KXKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:37:14 -0500
Date: Thu, 24 Nov 2011 11:37:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, len.brown@intel.com,
        tj@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early
 exits in hibernation
Message-ID: <20111124103711.GA3734@elf.ucw.cz>
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com>
 <20111122114549.GC32023@elf.ucw.cz>
 <4ECBF271.3040308@linux.vnet.ibm.com>
 <201111222132.35984.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111222132.35984.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The first patch below does the cleanup, the second patch fixes the memory
> > leak and applies on top of the first patch.
> 
> Wait, wait.  These changes can be made in the 3.3 merge window, while I'd
> like the fix the bug _now_.
> 
> Does anyone have any _technical_ problem with my patch posted previously
> in this thread?

No, it was ok.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
