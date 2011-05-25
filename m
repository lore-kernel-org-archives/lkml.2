Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1EYOgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:36:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36490 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab1EYOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:36:08 -0400
Date: Wed, 25 May 2011 10:36:02 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Michael Witten <mfwitten@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
Message-ID: <20110525143602.GE8476@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
	Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
 <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
 <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
 <20110524181619.GC26055@thunk.org>
 <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>
 <1306297108.4819.28.camel@marge.simson.net>
 <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 02:20:09PM +0000, Michael Witten wrote:
> 
> Ted just got finished telling Richard that Richard thinks about tiny,
> nit-picky, really stupid stuff on which only egg-headed paper pushers
> waste time that they'll never get back.

There are people who spend hours and hours worrying about the fact
that if you try to unlink a directory, Linux will return EISDIR
instead of EPERM.  They will kill forests of trees, and cause tons and
tons of carbon dioxide to be released into the atmosphere travelling
to distant meetings in Singapore, Zurich, Japan, etc., to debate
standards that specify this kind of detail.  How much value does this
really add to the Linux ecosystem?    What would you call these people?

Now that the people who tried to lobby governments and academic
institutions (mostly in Europe) not to use Linux, all in the name of,
"because it's not Unix" are largely in full retreat, the answer is,
why, pretty much none.  This kind of requirement is largely gone in
most procurement contracts.

And of course, the supreme irony is that if your OS is encumbered with
AT&T copyrighted code, you can use the Unix trademark even if you are
not conformant to the Single Unix Specification.  (There's an escape
clause for AT&T derived-Unix systems, which are automatically "Unix"
even if they fail the SUS.)

Given all of that, what _use_ is the Single Unix Specification at this
point?  What's the _point_?

And what name would you propose to call people who are worried about
whether or not Linux is "Unix compatible" (whatever the hell that
means)?  Especially when the rest of the world is worried about being
"Linux compatible", and a huge amount of software is targetted first
for Linux.

This idea that Linux needs to care about being "Unix compatible" keeps
coming back from the grave, like some Buffy-the-vampire-slayer
monster.  It's time to slay it.

						- Ted
