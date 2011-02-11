Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1BKO1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:27:45 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46255 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756232Ab1BKO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:27:44 -0500
Date: Fri, 11 Feb 2011 15:27:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH 3/5] serial: unbreak billionton CF card
Message-ID: <20110211142732.GB3920@ucw.cz>
References: <20110131162852.GA22875@kroah.com>
 <1296491470-23096-3-git-send-email-gregkh@suse.de>
 <20110131214854.3bb53bd4@pyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131214854.3bb53bd4@pyx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From: Pavel Machek <pavel@ucw.cz>
> > 
> > Unbreak Billionton CF bluetooth card. This actually fixes a regression
> > on zaurus.
> 
> It also unbreaks a pile of other chips.
> 
> Properly this should be a revert of  commit
> 7a56aa45982bb87bfca98a2832b5ae782c03364a as far as I can see.

Well, IIRC (sorry, offline) that commit added two flags and only one
was harmful for me... so I only removed one.

Also I guess comment explaining what is going on there would is good.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
