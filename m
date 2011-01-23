Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1AWSAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:00:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:60716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1AWSAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:00:35 -0500
Date: Mon, 24 Jan 2011 02:59:52 +0900
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: unbreak billionton CF card (was Re: [000/152] 2.6.36.3-stable
 review)
Message-ID: <20110123175952.GA4199@suse.de>
References: <20110106002500.GA3172@kroah.com>
 <20110106134254.68fa27ac@lxorguk.ukuu.org.uk>
 <20110106215705.GA30799@suse.de>
 <20110107150724.GA29082@atrey.karlin.mff.cuni.cz>
 <20110107183716.GA14895@suse.de>
 <20110123130611.GA2713@ucw.cz>
 <20110123163154.GA1071@suse.de>
 <20110123170854.GA25287@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123170854.GA25287@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 06:08:54PM +0100, Pavel Machek wrote:
> > On Sun, Jan 23, 2011 at 02:06:11PM +0100, Pavel Machek wrote:
> > > Unbreak Billionton CF bluetooth card. This actually fixes a regression
> > > on zaurus.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > ---
> > > 
> > > (now fixed typo)
> > 
> > So you mean the version that I just accepted into my tree is wrong?
> > What's wrong with it?  Care to provide the diff between the two?
> 
> Sorry about that. Typo is in comment -> not really important. Someone
> spotted it, so... feel free to keep old version.

Great, I'll keep that one, it will get pushed to Linus soon.

thanks,

greg k-h
