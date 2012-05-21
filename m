Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2EUUjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:39:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44699 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2EUUjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:39:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 00/16] vfs: atomic open v5 (part 1)
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFxKdouPmn0NTyDiNbOmgJJv3uSzy73PrDwmjWbFOXmwHQ@mail.gmail.com>
Date: Mon, 21 May 2012 22:39:38 +0200
In-Reply-To: <CA+55aFxKdouPmn0NTyDiNbOmgJJv3uSzy73PrDwmjWbFOXmwHQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 21 May 2012 09:27:45 -0700")
Message-ID: <87obphtgj9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, May 21, 2012 at 8:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> This is part 1 of the atomic open series.  The second part is also ready for
>> review and I'll post it once this first part is accepted.
>
> You should probably double-check against my vfs (especially dentry)
> cleanups that I just merged and pushed out.
>
> I think they all are at a lower level than your patches, and won't
> affect any of them, but I thought I'd mention it just in case, since
> my patch-series also touches fs/namei.c (but it's really just because
> of __d_lookup_rcu() calling convention changes, and think all of your
> patches are for the later phases)

Yes, I checked and they are independent.

I found some issues with the dentry_cmp() code and your changes which
I'll post separately.

Thanks,
Miklos
