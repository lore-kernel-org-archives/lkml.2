Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2EWW2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:28:32 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46692 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2EWW2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FBD5826.3070004@garzik.org>
References: <20120523192826.GA4447@havoc.gtf.org> <CA+55aFyTDK50z7sCfRD_nzAKmWpjABxRx1f=j8i9jUUXNgHjzg@mail.gmail.com>
 <4FBD5826.3070004@garzik.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 15:28:09 -0700
X-Google-Sender-Auth: 9YASKlbJV_wyNQIgrgyWo6VAy9U
Message-ID: <CA+55aFwb-cMTuEFaOW=zwLyk_J8eeLkUs-D0DRO7r-9t7k5crQ@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.5
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 2:35 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> hmmm, can you try again?  The output of
>
> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=summary
>
> and
>
> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=tag;h=4560c1c455fb87ba3013967d6ed5d0b1d18cc109
>
> looks correct, so I think there was a mirroring delay.

No. Look closers.

You've created a tag called "tag/upstream-linus", and that's the one
you asked me to pull.

But looking at gitweb, there is *also* a tag called just
"upstream-linus", and that's the one you probably *meant* me to pull.

If you had asked me to pull "tags/upstream-linus" (note: "tags/" vs
"tag/"), that would have indicated that it's in the "tags" namespace
and I would have gotten the one you meant.

I'd suggest you delete the old confused "tag/upstream-linus" tag (aka
"tags/tag/upstream-linus").

                    Linus
