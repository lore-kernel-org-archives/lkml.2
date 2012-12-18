Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2LRUjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:39:17 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65374 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:39:13 -0500
MIME-Version: 1.0
In-Reply-To: <50CF6FC5.20005@kernel.org>
References: <50CF6FC5.20005@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Dec 2012 12:38:52 -0800
X-Google-Sender-Auth: LmfIRglgRTZb8jsFyKYcUXwEnR4
Message-ID: <CA+55aFxrqUErKG8n1gSGER50_6mSh3DNpiQV0RT1VVaOFOT_VA@mail.gmail.com>
Subject: Re: [GIT PULL] power tools for Linux-3.8
To: Len Brown <lenb@kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:17 AM, Len Brown <lenb@kernel.org> wrote:
>
> There will be a logical conflict with the uapi changes
> which breaks the turbostat build.  It can be fixed this way:

I *think* you meant to point me at the 'release' branch, so that's
what I pulled.

What you actually pointed me at was the 'next' branch:

>   git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next

which had that fixed up as a separate commit (which breaks bisecting
the build, but I guess that doesn't much matter for something small
like turbostat).

            Linus
