Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2FEPkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:40:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41209 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2FEPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 08:39:58 -0700
X-Google-Sender-Auth: l0zHUxfMTvzRsOylAL1vqbeIUgU
Message-ID: <CA+55aFwNWOFj445DQ5i_Jv9dmcteWmveKxQjYx=mso+TkkeJWg@mail.gmail.com>
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, dhowells@redhat.com,
        mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 6:10 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This version has one bugfix and several cleanups, reported by David Howells.
> Also updated documentation in Documentation/filesytems/{vfs.txt,Locking}.

I assume the "one bugfix" is against an earlier version of this
series, not against the currently merged stuff? Because this is too
late for 3.5, so if the bugfix is for current code, please send that
separately..

              Linus
