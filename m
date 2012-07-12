Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab2GLSQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:16:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52383 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2GLSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:16:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120712175737.GA18349@thunk.org>
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
 <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com>
 <20120712152740.GB14792@thunk.org> <CAB=NE6Vw0AR-eOZ90T=45M=O=7YkujFOYz7S3fviKYuTDa=JCQ@mail.gmail.com>
 <20120712175737.GA18349@thunk.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 12 Jul 2012 11:16:24 -0700
X-Google-Sender-Auth: 6qqKaJNv64j3gS2Fvj1IDMSsQks
Message-ID: <CAB=NE6WxYcuNjNTKEdd1qArHzK6-GHBRT_Y9OHat7Tcik5K09A@mail.gmail.com>
Subject: Re: [PATCH 4/4] copyleft-next: embrace the Signed-off-by practice
To: "Ted Ts'o" <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Richard Fontana <fontana2012@gmail.com>,
        "Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:57 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 12, 2012 at 10:30:59AM -0700, Luis R. Rodriguez wrote:
>> Its unclear to me if this is the case for copyleft-next, so lets test
>> it out and get this clarified once and for all. Even though one may be
>> supportive of the philosophical evolutions of the ideas of copyleft I
>> have been wondering and personally hoping Fontana would consider
>> copyleft-next not as an effort to lead *philosophical evolutions* with
>> regards to *freedoms on copyleft* but instead -- addressing practical
>> issues that prevented the GPLv3 from being embraced in Linux. That is
>> bug fixing the GPLv3 in so far as Linux is concerned. Its worth being
>> explicitly clear so I'll send a patch to try to remove the Tivoization
>> clauses. This can then formally be NACKed or ACKed, or issues be
>> addressed. I should note that Fontana has indicated that he views
>> copyleft-next not as his project but that of the community's. I'm
>> hoping the Linux kernel community is part of this community.
>
> Well, at the risk of starting a long flame war on licensing issues on
> LKML, which I'm sure would not get us thanks from anyone, we do need
> to acknowledge that there are people "in the community" who believe
> very strongly in the anti-Tivoization clause.

I'm glad you're acknowledging this, thanks.

> Indeed, there are others who are even more extreme, and would have preferred that the
> restrictions embodied in the Affero General Public License would get
> incorporated into the GPLv3.

Holy Google, I didn't know these actual contributors existed :)

> Very fortunately (IMHO) this idea did
> not get traction, but the point remains that there's a very wide
> diversity of opinion "in the community" about what sort of
> restrictions and how viral a Copyleft license "should" be.

Makes sense.

>> It does make me wonder -- if the goal of copyleft-next is not to help
>> address *our* concerns with evolutions on copyleft in the Linux kernel
>> community if we ourselves can simply consider doing something similar
>> where we *do* address such things.
>
> Yes, but is it worth it?  The patent language could get a bit
> stronger, and legal language would get a bit more clear; but the GPLv2
> has the advantage that it's time tested and well understood.  A new
> license would take a huge amount of work, and it's not clear the
> benefits outweigh the costs.

Great points. There are a few boring non controversial updates like
requirements for redistribution using more reasonable modern
technologies that may be worth accepting as obvious. At the very least
these sort of things are with considering IMHO. Another worthy point
was the removal of the death penalty.

> And I'm not just talking about the work of revising the license,

Which is why this is a project -- so that those who are attorneys can
go off and play while we developers go off and do what we do better.

> getting lawyers to sign off on it, etc., but also the work of getting
> all of the copyright holders (including the corporate ones) to sign
> off on the license change.

Great point, if an explcit ACK is *not* required would it be worth it then?

But do we require an explicit ACK if the license is compatible and all
that is being done is updating the license to account for new
technologies, and a maybe the death penalty ? My understanding is that
we would require the explicit ACK *if* the clause on the file does not
have "or later" clause for the GPLv2.

We even have developers now who have died! If we are indeed required
to get explicit ACKs I agree its a complex requirement and an
unpractical thing to try to do then.

But -- I do hope there there may be some alternative option here...

> Then there's also the license
> incompatibility issue problem....  Bottom line is, even if the
> Copyright Next license, or some fork of the Copyright Next License,
> had the anti-Tivoization issue addressed to the kernel community's
> satisfaction, is it worth the effort to move the Linux Kernel to a
> newer license?  There are benefits, definitely; but there are also a
> large set of costs.

Its a great point but we also have to consider the other end of this:
if we do not ever update the license, does it have any other
implications ? What's the cost of that ? The only things I can think
of is perhaps the death penalty, technology used to redistribute, and
perhaps addressing any implicit patent grant ideas but this last one
may be controversial to address, not sure.

  Luis
