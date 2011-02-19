Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1BSRqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 12:46:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35747 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753523Ab1BSRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 12:46:09 -0500
Date: Sat, 19 Feb 2011 18:45:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110219174549.GA18230@ucw.cz>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <201102100722.47854.manningc2@actrix.gen.nz>
 <20110216080419.GA21261@infradead.org>
 <201102171112.07101.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171112.07101.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > remember you can get media from all over the place. 
> 
> No you can't. This is a flash file system for soldered down flash. I think 
> that is a fundamental place where your understanding of what yaffs is falls 
> down.

That needs to go into Documentation/ somewhere...

...so you can't for example prepare yaffs image on host before copying
it to target? What is gained by not having on-disk format?

> > If you can't encode these difference in your on-disk format it has
> > absolutely no business going into mainline with this format.
> 
> Yaffs does not really have an on-disk format like most other fs do.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
