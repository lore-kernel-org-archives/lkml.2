Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2JGJpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:45:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45902 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2JGJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <7367.1349344178@warthog.procyon.org.uk>
References: <alpine.DEB.2.00.1210040456090.3115@skynet.skynet.ie>
 <CA+55aFzuHdT5NLGTd-+2hPvV4uzWxT+dTFZ5kCrWS+8-1zDtOA@mail.gmail.com> <7367.1349344178@warthog.procyon.org.uk>
From: Shentino <shentino@gmail.com>
Date: Sun, 7 Oct 2012 02:45:05 -0700
Message-ID: <CAGDaZ_q389PAnZ=UgPdx7Lz1GgUaq=4q1WehK1TZhEuL88BK8Q@mail.gmail.com>
Subject: Re: [git pull] drm merge for rc1 (part 1)
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 2:49 AM, David Howells <dhowells@redhat.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> Ok, as usual I actually wanted to do the merge myself despite the
>> annoying conflicts (this *really* is the last time I will ever accept
>> any header file "cleanups" - they simply aren't worth the pain).
>
> There was a reason I asked you to pull the patches at the *end* of the merge
> window, and a reason I asked you to give me a chance to regenerate the patches
> before you pulled them.
>
> Anyway, I can feed much of the main set of patches through subsystem trees now
> - so thanks for that at least.

Saw this LWN article about the UAPI cleanup.

http://lwn.net/Articles/507794/

Have you had much feedback from subsystem maintainers about accepting
these?  I'm no kernel developer yet but I have had a keen interest in
this patch set ever since I heard of it.

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
