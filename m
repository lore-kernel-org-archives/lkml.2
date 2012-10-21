Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2JUKmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:42:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38261 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2JUKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:42:23 -0400
Date: Sun, 21 Oct 2012 12:42:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Staging: winbond: Fixed coding style issues
Message-ID: <20121021104217.GE14031@elf.ucw.cz>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2012-10-12 22:07:06, Adil Mujeeb wrote:
> 
> winbond directory files have lots of coding style issues. The patch
set tries to remove *most* (if not all) of the coding style
issues. checkpatch.pl script is still complaining (like 80 characters
limit) but major part of the serious coding style issues have been
rectified. 

ACK on patches except 2 and 5. Plus if you could keep the printks,
that would be great. When the driver is debugged and in wide use, we
can remove them, but now they are useful...

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
