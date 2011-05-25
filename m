Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1EYEtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:49:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36634 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1EYEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T9HKUNkDSpJs+xqrCNOgrgXRzSULgXDBLtLe3sn/mdmJtRUEOBXMyI4IqYspwXcc3y
         qlvax0lD0t/+OnnC4u/GLAdI1QJhanlEzU9Nmkl0eJy6FslktA10wFpKWkJtgedj7NDC
         tQqX4VLUqptGzEivm0TuVsByTuOa7EZ21zsts=
Date: Wed, 25 May 2011 00:47:18 -0400
From: porpen <porpen@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (Short?) merge window reminder
Message-ID: <20110525044718.GA4647@bench>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 23, 2011 at 12:13:29PM -0700, Linus Torvalds wrote:
> PS. The voices in my head also tell me that the numbers are getting
> too big. I may just call the thing 2.8.0. And I almost guarantee that
> this PS is going to result in more discussion than the rest, but when
> the voices tell me to do things, I listen.

With all the discussion about matching the year, keeping the numbers smallish and breaking build/test scripts...

Why not match the year this way: v2.11 = 2011

So, to get there, how about: 
v2.6.39 current
v2.6.40 
v2.7.?  (see below)
v2.11.0 sometime this year maybe or skipped.
v2.12.? early 2012.
v2.13.? early 2013.
and so on...

To hell with making the months match up to anything.  IMHO, that's micromanaging BS that will cause recurring troubles forever.

Advantages: 
 -Build & test scripts won't break for a while. (see note about this below)
 -Major and Minor numbers together approximately match the year of release.
 -Subreleases don't get too big. e.g. with 2 week releases, v2.12.x might reach .26 or .27 and resets with v2.13.0 

Disadvantages:
 -in the year 2100 the version will have to leap to v21.0 and that numbering will last until v29.99 or so.
 -most of us won't live long enough to see v31.14 or v42.0

The build scripts would finally break in the year 25500 with the step after kernel v254.99.?.  I suspect one of our decendants in the next 23.5 thousand years can figure out how to fix that.

IMHO, this may be a least effort compromise between the keep-numbers-small camp, the match-the-year camp and the don't-break-scripts camp.

Of course, math junkies like me would love to see v2.7.18.28 at some point in the process.  Could we jump straight to that just before we leap to v2.11.0 or whatever numbering is chosen please?

-phil
