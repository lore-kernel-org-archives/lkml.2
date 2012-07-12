Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab2GLRbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:31:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40682 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab2GLRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120712152740.GB14792@thunk.org>
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
 <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com> <20120712152740.GB14792@thunk.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 12 Jul 2012 10:30:59 -0700
X-Google-Sender-Auth: N224-z6t2vAx6-L_S0z0_HZns80
Message-ID: <CAB=NE6Vw0AR-eOZ90T=45M=O=7YkujFOYz7S3fviKYuTDa=JCQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] copyleft-next: embrace the Signed-off-by practice
To: "Ted Ts'o" <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Richard Fontana <fontana2012@gmail.com>,
        "Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 8:27 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Jul 11, 2012 at 05:44:49PM -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> The idea is taken from Linus Torvald's subsurface
>> project [0] README file. The Signed-off-by is widely
>> used in public projects and we stand to gain to make
>> its usage more prevalent. The meaning of the
>> Signed-off-by is borrowed from the Linux kernel's.
>>
>> [0] git://github.com/torvalds/subsurface.git
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>
> I wonder why you're cc'ing the linux-kernel mailing list?

Simply because there is no public mailing list for it yet and given
the nature of the license I wanted to ensure changes get as much
public review as possible, and what better and more public place than
lkml ? What can I say -- I did have hope for it to be used on Linux
but more on that below.

> I've checked the copyleft-next clause, and the anti-Tivoization clauses,
> which was one of the primary reasons articulated by many kernel
> developers --- including Linus Torvalds --- for not using GPLv3, is
> still in the Copyleft-next license.
>
> My understanding of Richard Fontana's past public positions was that
> he was supportive of that part of the GPLv3 license, and so I had
> assumed the Copyleft-next effort would be irrelevant as far as the
> Linux Kernel was concerned.

Its unclear to me if this is the case for copyleft-next, so lets test
it out and get this clarified once and for all. Even though one may be
supportive of the philosophical evolutions of the ideas of copyleft I
have been wondering and personally hoping Fontana would consider
copyleft-next not as an effort to lead *philosophical evolutions* with
regards to *freedoms on copyleft* but instead -- addressing practical
issues that prevented the GPLv3 from being embraced in Linux. That is
bug fixing the GPLv3 in so far as Linux is concerned. Its worth being
explicitly clear so I'll send a patch to try to remove the Tivoization
clauses. This can then formally be NACKed or ACKed, or issues be
addressed. I should note that Fontana has indicated that he views
copyleft-next not as his project but that of the community's. I'm
hoping the Linux kernel community is part of this community.

If one objective is not to remove Tivoization or address other kernel
developer's concerns with the GPLv3 then we can rest assured we Linux
kernel developers can simply disregard copyleft-next.

It does make me wonder -- if the goal of copyleft-next is not to help
address *our* concerns with evolutions on copyleft in the Linux kernel
community if we ourselves can simply consider doing something similar
where we *do* address such things.

> Even if I am wrong about that (and I would be delighted if the answer
> was that one of the Copyright-next's goals was to resolve this barrier
> of the kernel moving off of GPLv2), it still would seem to me to be
> out of scope of the LKML.

Thanks, unfortunately no alternative list is yet created, so I'll
respin my patches given that they seem to need a rebase now, and also
try to remove Tivoization -- moving forwards at the very least we can
get addressed whether or not this license can eventually be useful for
Linux or not and if not I'll know not to care for it with hopes for
Linux.

  Luis
