Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1JMMiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:38:14 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:51622 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1JMMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:38:13 -0400
Message-ID: <4E96DBB2.9020104@tilera.com>
Date: Thu, 13 Oct 2011 08:38:10 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/tile update for 3.1
References: <4E94B9FD.5030500@tilera.com> <CA+55aFwLWrurcrjX86wBR_eDurvGnsYGOqORXZZ9vyzdM2Ff2Q@mail.gmail.com>
In-Reply-To: <CA+55aFwLWrurcrjX86wBR_eDurvGnsYGOqORXZZ9vyzdM2Ff2Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 2:31 AM, Linus Torvalds wrote:
> On Wed, Oct 12, 2011 at 9:49 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> Please pull the following trivial change for 3.1 from:
>>
>>  git://github.com/cmetcalf-tilera/linux-tile.git stable
>>
>> This change allows 3.1-rc9 to build for the Tile architecture.  A bombing
>> of <asm/atomic.h> to <linux/atomic.h> erroneously modified a couple
>> of places where we were relying on some assembly constants in the tile
>> <asm/atomic.h>.  Thanks!
> This is not *at*all* what I get when I pull that branch.
>
> I get a merge and two other commits too.
>
> Not pulled.

Mea culpa.  I've fixed the tree, so if you could pull again, it should now
have what the original message described.

No doubt my screwup is just a variant on a story you've heard more than a
few times, but for the record, here's some detail.  I saw the extra two
commits, which made no sense to me, so I examined one of the files that the
request-pull message described as different and saw no difference, so I
assumed it was just some minor confusion (maybe due to github vs
kernel.org).  Turns out that commit was a duplicate that had been in my
tree since June that I'd forgotten about, and the merge represented git
merging in the same semantic commit from a different tree.  So, I've now
rolled back my stable tree to June, re-applied just the patch I wanted you
to pull, and retested the tree -- and confirmed that git request-pull
actually now produces the output in my earlier email.

I'll make sure this doesn't happen again.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

