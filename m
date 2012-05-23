Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2EWCyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:54:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49425 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2EWCyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120523024950.3905.89811.stgit@perseus.themaw.net>
References: <20120523024950.3905.89811.stgit@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 May 2012 19:53:49 -0700
X-Google-Sender-Auth: GSOD2dZzaPBe8BecpXA-kMXsNZQ
Message-ID: <CA+55aFwCESHx0d+ZEe-zi3PS6mkMaMng75Dnfit93cTwhb5gSg@mail.gmail.com>
Subject: Re: [PATCH] autofs4 - fix get_next_positive_subdir()
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@linux.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 7:49 PM, Ian Kent <ikent@redhat.com> wrote:
>
> The locking for the list traversal in get_next_positive_subdir() is
> wrong, so fix it.

As an explanation, this kind of thing is totally useless. It doesn't
actually give any information at all. It's like saying "change
locking"

What happened, and why? Why is the new nested spinlock ok and won't
deadlock against other nested users? Wazzup?

                 Linus
