Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1KACaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 22:30:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1KACaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 22:30:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132633270"
Message-ID: <a0e26bc1328fbfe00f01b8e225f2cf1a.squirrel@www.codeaurora.org>
In-Reply-To: <CA+55aFw2T0_mD1rM+dTz28fZPtSVhVDTWCYxXDvohwCwNk+b2g@mail.gmail.com>
References: <093448$3uek00@wolverine01.qualcomm.com>
    <CA+55aFw2T0_mD1rM+dTz28fZPtSVhVDTWCYxXDvohwCwNk+b2g@mail.gmail.com>
Date: Mon, 31 Oct 2011 19:30:08 -0700 (PDT)
Subject: Re: [PATCH v5 00/36] Hexagon: Add support for Qualcomm Hexagon 
     architecture
From: rkuo@codeaurora.org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Richard Kuo" <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        "Linas Vepstas" <linas@codeaurora.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Oct 31, 2011 at 4:58 PM, Richard Kuo <rkuo@codeaurora.org> wrote:
>>
>> Please let me know if there's anything else you require of these
>> patches.
>
> So there's something odd going on with the Sign-off's, which makes me
> unhappy. It also makes me wonder if the authorship is properly
> attributed.
>
> Some of these things are signed off by Linas Vepstas. In fact, some of
> them are *only* signed off on by him, not by you. Which is definitely
> wrong. But it makes me wonder if the authorship is buggered up, and
> those patches maybe should have a "From: Linas Vepstas
> <linas@codeaurora.org>" on them too.
>
> Example of this: "[PATCH v5 12/36] Hexagon: Export ksyms defined in
> assembly files." (but 13/36, 31/36 and 36/36 were that way too).
>
> Others are signed off by both Linas Vepstas and you, but in an odd
> order. Since you're sending them to me, I'd expect your sign-off to be
> last, but it isn't. So the sign-off sequence makes it look like they
> were sent by Linas, even though I got them from you.
>
> So I'd like some clarification on this, and I do need *your* sign-off
> on them all since you're sending them to me.
>
> You don't have to re-send, but you do have to explain whether perhaps
> Linas should be author (and why the odd order of sign-offs) and
> basically do a "yeah, I sign off on those patches" with a full listing
> of the patches in question so that I have it for the record.
>
>                        Linus
>

OK, my mistake on these.  Linas did author those patches, but clearly
I'm in their path.  So, I sign off on:

[PATCH v5 12/36] Hexagon: Export ksyms defined in assembly files.
[PATCH v5 13/36] Hexagon: Support dynamic module loading.
[PATCH v5 31/36] Hexagon: kgdb support files
[PATCH v5 36/36] Add extra arch overrides to asm-generic/checksum.h

Many other times, I was the author, and Linas also had contributions to
the files as well, but again, if they're coming through me, my signed-off
should be last.  The From: is me because I imported all the files into git
from what we were doing previously.  The rest of the patches from now on
should have proper authorship.


Thanks,
Richard Kuo



