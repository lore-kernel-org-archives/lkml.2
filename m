Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971Ab2EOSBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:01:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2EOSBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:01:10 -0400
Date: Tue, 15 May 2012 20:01:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com
Subject: Re: 3.4.0-rc7 regression: bluetooth vs. s2ram
Message-ID: <20120515180105.GA1923@elf.ucw.cz>
References: <20120515131453.GA1936@elf.ucw.cz>
 <201205151529.01603.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205151529.01603.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-05-15 15:29:01, Oliver Neukum wrote:
> Am Dienstag, 15. Mai 2012, 15:14:57 schrieb Pavel Machek:
> > If I suspend without bnep0 active, resume works. 
> > 
> > (This has worked before, but "before" may mean 3.2 in this case).
> > 
> > Can someone test/reproduce this? Ideas?
> > 
> > PS: Under normal suspend/resume, I see these warnings in the
> > log. Maybe relevant?
> 
> Most likely. Something has introduced a bug that crashes if the controller
> over which a bnep is run is getting away. Does it survive a surprise removal
> of the BT device while bnep is up?

No, it does not. If I turn off hardware radio kill switch, machine
dies in the same way. So not just sleep related...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
