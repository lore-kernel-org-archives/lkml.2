Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2AIQn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:43:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35756 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2AIQn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 08:43:32 -0800
X-Google-Sender-Auth: jP37BvLWsWU8yoa82sam7AZ6FbU
Message-ID: <CA+55aFy-XiMR6XCudvjbPV8Q0cyDxy+iB_BnDxYOJTnskCkw9A@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        hch@infradead.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 2:58 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This patch adds a new dentry flag that is set when the dentry is removed
> from the lru and put on the list being processed by
> shrink_dentry_list().  The flag is cleared in dentry_lru_del() which is
> called if the dentry gets a new reference just before it's pruned.
>
> Thoughts?

Looks reasonable. Were you actually able to reproduce the hang, or how
did you notice?

Al, comments?

                           Linus
