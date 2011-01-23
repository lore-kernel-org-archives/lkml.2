Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab1AWRI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:08:56 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56242 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751095Ab1AWRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:08:55 -0500
Date: Sun, 23 Jan 2011 18:08:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: unbreak billionton CF card (was Re: [000/152] 2.6.36.3-stable
	review)
Message-ID: <20110123170854.GA25287@atrey.karlin.mff.cuni.cz>
References: <20110106002500.GA3172@kroah.com> <20110106134254.68fa27ac@lxorguk.ukuu.org.uk> <20110106215705.GA30799@suse.de> <20110107150724.GA29082@atrey.karlin.mff.cuni.cz> <20110107183716.GA14895@suse.de> <20110123130611.GA2713@ucw.cz> <20110123163154.GA1071@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123163154.GA1071@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jan 23, 2011 at 02:06:11PM +0100, Pavel Machek wrote:
> > Unbreak Billionton CF bluetooth card. This actually fixes a regression
> > on zaurus.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > ---
> > 
> > (now fixed typo)
> 
> So you mean the version that I just accepted into my tree is wrong?
> What's wrong with it?  Care to provide the diff between the two?

Sorry about that. Typo is in comment -> not really important. Someone
spotted it, so... feel free to keep old version.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
