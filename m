Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2K1Ufz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:35:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42523 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2K1Ufy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tyJmYup+wtzn4bxZ=P2imX9F_R6J94Xju=G7iEbFT4Lng@mail.gmail.com>
References: <alpine.DEB.2.00.1211220431150.14614@skynet.skynet.ie>
 <CA+55aFw3yqWRamfe3tn4Lh9G2BsuNd1RsST05=fc4jOoTLWsmw@mail.gmail.com> <CAPM=9tyJmYup+wtzn4bxZ=P2imX9F_R6J94Xju=G7iEbFT4Lng@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 12:35:32 -0800
X-Google-Sender-Auth: l4KoLPSEn-YttZY8r2nejaC0rP8
Message-ID: <CA+55aFz4=u12RcuSKp7nyynDmE13CtUg1A1HhYw2TckYsu9-YQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Hmm. For some reason this seems to have never gone out, and was in
my drafts folder. If you get it twice, my bad ]

On Thu, Nov 22, 2012 at 12:57 AM, Dave Airlie <airlied@gmail.com> wrote:
>
> Doh!, yes I picked wrong place to generate report from, okay here is
> one corresponding to what you saw,

You should never even need to "pick" any place to generate the report from.

Just do something like

   git fetch upstream

(where "upstream" is a branch description for the upstream repository
- see "man git-remote" etc, although you can obviously always just
type out the whole repo details etc in full if you would want to).
Note the "fetch" - not pull - you just want to get it, not merge it.

Then you can just point git pull-request at the upstream, and git wll
figure out what the latest common point is. No need for you to
manually try to figure it out.

                   Linus
