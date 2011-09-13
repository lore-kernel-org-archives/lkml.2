Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1IMONI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:13:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1IMONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:13:06 -0400
Date: Tue, 13 Sep 2011 16:12:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110913141158.GA7352@ucw.cz>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
 <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-08-22 11:30:33, Linus Torvalds wrote:
> On Fri, Aug 19, 2011 at 4:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Reposting due to popular demand. Several other people are running
> > into the same problem with all kinds of software.
> 
> I have heard this several times now, but nobody actually ever says
> *what* is broken.
> 
> The Fedora people seem to have done the 2.6.40 thing without any
> actual reason, for example (the two programs they claim were broken
> were things that they had already fixed in rawhide, afaik).
> 
> I'm not at all interested in these kinds of "all kinds of software" reports.
> 
> Details. Examples. Name the f&*cking names already. Shame them publicly.

ketchup :-(. And no, it is probably not what you wanted, and no, it is
not easy to fix.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
