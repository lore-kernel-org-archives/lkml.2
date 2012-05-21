Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2EUQ2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:28:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46040 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2EUQ2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:28:08 -0400
MIME-Version: 1.0
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 09:27:45 -0700
X-Google-Sender-Auth: CD2Bu77e32kITmaM4vqt9c0LwIo
Message-ID: <CA+55aFxKdouPmn0NTyDiNbOmgJJv3uSzy73PrDwmjWbFOXmwHQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] vfs: atomic open v5 (part 1)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 8:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> This is part 1 of the atomic open series.  The second part is also ready for
> review and I'll post it once this first part is accepted.

You should probably double-check against my vfs (especially dentry)
cleanups that I just merged and pushed out.

I think they all are at a lower level than your patches, and won't
affect any of them, but I thought I'd mention it just in case, since
my patch-series also touches fs/namei.c (but it's really just because
of __d_lookup_rcu() calling convention changes, and think all of your
patches are for the later phases)

                        Linus
