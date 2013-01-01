Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3AAWue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:50:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54657 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3AAWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:50:33 -0500
Date: Tue, 1 Jan 2013 23:50:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: NeilBrown <neilb@suse.de>
Cc: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] AES instead of SHA1 for /dev/urandom
Message-ID: <20130101225029.GA9001@amd.pavel.ucw.cz>
References: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
 <20121212130826.7940b428@notabene.brown>
 <20121212085815.GA3151@domone.kolej.mff.cuni.cz>
 <20121212201016.5342ce32@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121212201016.5342ce32@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2012-12-12 20:10:16, NeilBrown wrote:
> On Wed, 12 Dec 2012 09:58:16 +0100 Ondřej Bílka <neleai@seznam.cz> wrote:
> 
> > On Wed, Dec 12, 2012 at 01:08:26PM +1100, NeilBrown wrote:
> > > On Wed, 12 Dec 2012 03:03:54 +0100 Ondřej Bílka <neleai@seznam.cz> wrote:
> > > 
> > > > I consider to speed-up /dev/urandom on recent intel processors by
> > > > using hardware aes. Same for accelerated aes crypto.
> > > > 
> > > > Would you accept a patch if I wrote it?
> > > 
> > > Have you read  https://lwn.net/Articles/525459  ?
> > > 
> > Yes
> > > In particular the paragraph containing:
> > > 
> > >    A member of the audience asked why the kernel couldn't just do away with
> > >    the existing system and use the HWRNG directly.
> > > 
> > > Does that answer your question in any way?
> > > 
> > No as AES is a HWRNG about as much as horse is type of automobile.
> 
> Yes, of course.  Thanks.

Dunno. Some people don't trust HWRNG for various reasons.... (what if
it malfunctions? what if it is backdoored?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
