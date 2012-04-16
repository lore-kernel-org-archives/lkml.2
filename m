Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DPTJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:09:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2DPTJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120416.142728.864894452301706752.davem@davemloft.net>
References: <20120416091719.GA4113@gmail.com> <20120416.142728.864894452301706752.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Apr 2012 12:09:12 -0700
X-Google-Sender-Auth: ePPwxa8SE5GSlnm3zwz6m_1YzH4
Message-ID: <CA+55aFzz9uu=R6zKy=r0JSpjCgtfoMCLvcLwdBXhhJ4=u-PagA@mail.gmail.com>
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests for
 braces, comments and casts
To: David Miller <davem@davemloft.net>
Cc: mingo@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:27 AM, David Miller <davem@davemloft.net> wrote:
>
> I would like to formally propose that we change CodingStyle so that
> our comments are of the form:
>
>        /* XXX
>         * YYY
>         */
>
> So that we can save one line of vertical space.

Ugh, I personally hate it. No way will we make that the recommended
version, even if it might be an acceptable substitute in some
subsystems.

It looks unbalanced. If you want to save that vertical space, just use
C++ style comments instead, for chissake! Then you save *two* lines,
without the unbalanced thing, and just write it as

    // XXX
    // YYY

which is much preferred.

Your suggested format just sucks, and has the worst of all worlds.

                      Linus
