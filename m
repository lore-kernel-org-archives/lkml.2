Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161354Ab2GLR5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:57:43 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38730 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab2GLR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:57:41 -0400
Date: Thu, 12 Jul 2012 13:57:37 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Richard Fontana <fontana2012@gmail.com>, "Bradley M. Kuhn" <bkuhn@ebb.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] copyleft-next: embrace the Signed-off-by practice
Message-ID: <20120712175737.GA18349@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Richard Fontana <fontana2012@gmail.com>,
	"Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
 <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com>
 <20120712152740.GB14792@thunk.org>
 <CAB=NE6Vw0AR-eOZ90T=45M=O=7YkujFOYz7S3fviKYuTDa=JCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6Vw0AR-eOZ90T=45M=O=7YkujFOYz7S3fviKYuTDa=JCQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:30:59AM -0700, Luis R. Rodriguez wrote:
> Its unclear to me if this is the case for copyleft-next, so lets test
> it out and get this clarified once and for all. Even though one may be
> supportive of the philosophical evolutions of the ideas of copyleft I
> have been wondering and personally hoping Fontana would consider
> copyleft-next not as an effort to lead *philosophical evolutions* with
> regards to *freedoms on copyleft* but instead -- addressing practical
> issues that prevented the GPLv3 from being embraced in Linux. That is
> bug fixing the GPLv3 in so far as Linux is concerned. Its worth being
> explicitly clear so I'll send a patch to try to remove the Tivoization
> clauses. This can then formally be NACKed or ACKed, or issues be
> addressed. I should note that Fontana has indicated that he views
> copyleft-next not as his project but that of the community's. I'm
> hoping the Linux kernel community is part of this community.

Well, at the risk of starting a long flame war on licensing issues on
LKML, which I'm sure would not get us thanks from anyone, we do need
to acknowledge that there are people "in the community" who believe
very strongly in the anti-Tivoization clause.  Indeed, there are
others who are even more extreme, and would have preferred that the
restrictions embodied in the Affero General Public License would get
incorporated into the GPLv3.  Very fortunately (IMHO) this idea did
not get traction, but the point remains that there's a very wide
diversity of opinion "in the community" about what sort of
restrictions and how viral a Copyleft license "should" be.

> It does make me wonder -- if the goal of copyleft-next is not to help
> address *our* concerns with evolutions on copyleft in the Linux kernel
> community if we ourselves can simply consider doing something similar
> where we *do* address such things.

Yes, but is it worth it?  The patent language could get a bit
stronger, and legal language would get a bit more clear; but the GPLv2
has the advantage that it's time tested and well understood.  A new
license would take a huge amount of work, and it's not clear the
benefits outweigh the costs.

And I'm not just talking about the work of revising the license,
getting lawyers to sign off on it, etc., but also the work of getting
all of the copyright holders (including the corporate ones) to sign
off on the license change.  Then there's also the license
incompatibility issue problem....  Bottom line is, even if the
Copyright Next license, or some fork of the Copyright Next License,
had the anti-Tivoization issue addressed to the kernel community's
satisfaction, is it worth the effort to move the Linux Kernel to a
newer license?  There are benefits, definitely; but there are also a
large set of costs.

Regards,

					- Ted
