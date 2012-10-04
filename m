Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748Ab2JDQAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:00:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60657 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965618Ab2JDQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <1349339900.4260.10.camel@pasglop>
References: <1349339900.4260.10.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Oct 2012 09:00:14 -0700
X-Google-Sender-Auth: HrejPDN6b_Yf2bLpaKVNVfbqzl8
Message-ID: <CA+55aFxbzeNG=sAQvPcE56rEpAbACqM04m2s73BzXVgK+PCnaQ@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 1:38 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> First, however, a note about the pull request details ... the diffstat looks
> completely on crack, any idea what's up ? It sees piles of files modified
> in various other archs & generic code but I see no patch in that branch
> that touches any of them.

So this happens if you have "reverse merges" (ie you've pulled my
tree, or some other tree I've pulled), and there is no longer a single
clear common point that you started from. In that case, there is no
simple diff for the "what has changed since that original point", and
to get the diff for the merge you actually have to do the merge and
check the end result. git-request-pull doesn't do that, it just
assumes it's the simple case of some single common point.

The fact that you haven't seen it until now just means that you've
generally done a good job at keeping your powerpc tree "clean" from
other trees, and containing only your own work.

               Linus
