Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0HCG4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:56:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755238Ab0HCG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:56:01 -0400
Date: Tue, 3 Aug 2010 08:55:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: Nigel's current for-rafael queue
Message-ID: <20100803065543.GF3344@ucw.cz>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-06-02 22:18:59, Nigel Cunningham wrote:
> Hi all.
> 
> Here is my current patch queue.
> 
> Taken together, the patches implement the separation of low level
> block i/o into a separate file, switch from using swap_map_pages
> to extents stores prior to the 'header' page and implement fully
> asynchronous (rather than batched I/O). I have only run it under
> VMware so far, but would estimate a doubling in speed due to the
> async i/o.

Do you have any numbers from real hw? Could similar speedup be
accomplished by just increasing the batch size?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
