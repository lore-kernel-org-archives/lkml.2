Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1KABKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:10:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1KABKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <093448$3uek00@wolverine01.qualcomm.com>
References: <093448$3uek00@wolverine01.qualcomm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 18:10:13 -0700
X-Google-Sender-Auth: Y1pWD2ZczLUumCwefqFGYYUgmK0
Message-ID: <CA+55aFw2T0_mD1rM+dTz28fZPtSVhVDTWCYxXDvohwCwNk+b2g@mail.gmail.com>
Subject: Re: [PATCH v5 00/36] Hexagon: Add support for Qualcomm Hexagon architecture
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 4:58 PM, Richard Kuo <rkuo@codeaurora.org> wrote:
>
> Please let me know if there's anything else you require of these patches.

So there's something odd going on with the Sign-off's, which makes me
unhappy. It also makes me wonder if the authorship is properly
attributed.

Some of these things are signed off by Linas Vepstas. In fact, some of
them are *only* signed off on by him, not by you. Which is definitely
wrong. But it makes me wonder if the authorship is buggered up, and
those patches maybe should have a "From: Linas Vepstas
<linas@codeaurora.org>" on them too.

Example of this: "[PATCH v5 12/36] Hexagon: Export ksyms defined in
assembly files." (but 13/36, 31/36 and 36/36 were that way too).

Others are signed off by both Linas Vepstas and you, but in an odd
order. Since you're sending them to me, I'd expect your sign-off to be
last, but it isn't. So the sign-off sequence makes it look like they
were sent by Linas, even though I got them from you.

So I'd like some clarification on this, and I do need *your* sign-off
on them all since you're sending them to me.

You don't have to re-send, but you do have to explain whether perhaps
Linas should be author (and why the odd order of sign-offs) and
basically do a "yeah, I sign off on those patches" with a full listing
of the patches in question so that I have it for the record.

                       Linus
