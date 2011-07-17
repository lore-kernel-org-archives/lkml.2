Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1GQW7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 18:59:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab1GQW7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 18:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Jul 2011 15:59:26 -0700
Message-ID: <CA+55aFzDtunzxNf9TGJMt+VVu-ox1eBb5m1Tbn=+50hR6_=Bqg@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 3:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The above (whitespace-damaged) patch may look trivial, but it is
> *entirely* untested, and maybe my gut feel that the above is the right
> way to solve the problem is just wrong.
>
> Al, any reactions? Hugh, does the above patch work for your
> stress-test case? Or, indeed, at all?

Hmm, it worked for my small test, including under memory pressure that
was shrinking dentries. But my test is not the kind of stress-test
that you clearly have, so that only means that it has not *really*
obvious breakages.

                     Linus
