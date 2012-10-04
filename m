Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab2JDGwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:52:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56592 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2JDGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210040456090.3115@skynet.skynet.ie>
References: <alpine.DEB.2.00.1210040456090.3115@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 23:51:43 -0700
X-Google-Sender-Auth: E1HRKSvxMfGFSpZ420EVg6bmL98
Message-ID: <CA+55aFzuHdT5NLGTd-+2hPvV4uzWxT+dTFZ5kCrWS+8-1zDtOA@mail.gmail.com>
Subject: Re: [git pull] drm merge for rc1 (part 1)
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 9:08 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> So this pull is for my drm-next-merged branch which is my drm-next branch
> merged with your tree, and some fixups applied to the merge.

Ok, as usual I actually wanted to do the merge myself despite the
annoying conflicts (this *really* is the last time I will ever accept
any header file "cleanups" - they simply aren't worth the pain).

My resolution was largely the same as yours, and I used your
pre-merged branch to check the end result. I do like being able to
double-check, and see the non-data-conflicting semantics conflicts
too.

Pushed out,

                Linus
