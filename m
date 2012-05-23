Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab2EWVG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:06:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63048 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2EWVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120523192826.GA4447@havoc.gtf.org>
References: <20120523192826.GA4447@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 14:06:33 -0700
X-Google-Sender-Auth: dDed2w_UFacPB9V5uTx34JwapGM
Message-ID: <CA+55aFyTDK50z7sCfRD_nzAKmWpjABxRx1f=j8i9jUUXNgHjzg@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.5
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:28 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Please pull 2fff27512600f9ad91335577e485a8552edb0abf from
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus

That's not what I get at all. I get your old stuff that I pulled early May.

I suspect you didn't force the tag update: tags aren't like branches,
so by default git will not just overwrite an old tag with a new tag.
Branches are *expected* to be mutable (well, at least if the changes
are fast-forwards), after all - but changing a tag is something you
need to be conscious about.

                               Linus
