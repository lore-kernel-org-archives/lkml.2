Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2CUXAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:00:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43760 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2CUXAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120321220652.GJ8451@sgi.com>
References: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
 <CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com> <20120321220652.GJ8451@sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 15:59:49 -0700
X-Google-Sender-Auth: tJ1qI95FcLgb-BIrVxQi7kXz1fU
Message-ID: <CA+55aFzzoLDs0MSo7zoNEDL7gzMmqR+Vr1WYh337xeSVyDhJ0w@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.4-rc1
To: Ben Myers <bpm@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 3:06 PM, Ben Myers <bpm@sgi.com> wrote:
>
> xfs/master contains scalability improvements for dquots, log grant code
> cleanups, plus bugfixes and cleanups large and small.

Shortlog and diffstat?

> Unfortunately the stuff in:  git://oss.sgi.com/xfs/xfs master
>
> Conflicts with the stuff in:  git://oss.sgi.com/xfs/xfs for-linus

There's still nothng in 'for-linus'.

> I've resolved the conflict here:  git://oss.sgi.com/xfs/xfs for-linus-merged

I actually prefer to merge things myself to see what is up, especially
since everybody else writes horrible merge messages (but also because
I simply want to know what the conflicts are). I appreciate more
complex pull requests that *also* have a "pre-merged" branch just in
case (I tend to use that for verification if there was anything even
remotely questionable going on), but I really do not generally want
pre-merging.

I'm used to resolving conflicts. I'm so used to it, in fact, that
there have been cases where I did it right despite not really knowing
the code and the maintainer did it wrong, just because I know what to
look for.

> I would like to figure out how to
> 1) send important bugfixes upstream after rc1, and
> 2) not hold up development commits to xfs/master, while
> 3) avoiding conflicts like this.

Avoiding conflicts isn't that important. Getting too many of them
implies that there is something odd going on. But a few conflicts due
to upstream bugfixes are basically "normal". Judging by the merge I
see, there wasn't anything complicated going on.

                           Linus
