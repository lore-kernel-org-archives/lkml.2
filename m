Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1GCRqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 13:46:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38753 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1GCRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 13:46:19 -0400
Date: Sun, 3 Jul 2011 19:46:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110703174616.GB26790@elf.ucw.cz>
References: <20110608074523.211912903@de.ibm.com>
 <201106121441.35059.rjw@sisk.pl>
 <20110614105001.2f991377@mschwide>
 <201106142250.15041.rjw@sisk.pl>
 <20110615093629.07f01779@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615093629.07f01779@mschwide>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think, however, that we really should try to merge them.  The only
> > difference seems to be how the additionally allocated pages will be populated
> > and what's going to happen to their contents during restore.
> > 
> > ACPI will simply copy the NVS memory to those pages, while S390 will save
> > the relevant storage key bits in there.
> 
> One complication to keep in mind is that we need to know which storage key
> goes to which page frame. We need something like the orig_bm/copy_bm or
> we'd have to store the pfn with the key. Simply storing the key for every
> page will make the array unnecessarily big.

How big is the overhead? In percent / in megabytes?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
