Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1LFQ2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:28:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1LFQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
References: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 08:27:50 -0800
X-Google-Sender-Auth: IlbATOkHztKAr8rpd8wU5klF4mM
Message-ID: <CA+55aFyFar45vTWb33FnJ1xv4zT+9XfnKBs=Xwx6-5O-RBHO4Q@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:21 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> 3 fixes, one for an ongoing Intel VT-d/Ironlake GPU that I've been
> testing, and one kexec fix from Jerome for an issue reported on the list
> where the gpu writeback engines need to be switched off, along with a
> trivial fix from Alex.

Quite frankly, I think it's too late for something like a kexec
bugfix. Nobody cares. So kexec doesn't work - that's not something
new. This doesn't smell like a regression to me. And the kcalloc
things you mention *sound* like some kind of cleanup crap.

The DRM layer has been fairly good for a few releases, but I'm getting
the feeling that I need to start pushing back, because I'm getting
stuff that I don't think matters, and shouldn't be sent to me after
-rc4.

So I'm not pulling this.

What the heck is up?

By now, I want fixes that either fix real regressions that people
*care* about, or that help new unreleased hardware that people *will*
care about and that cannot possibly mess up old users.

kexec? Who the f*ck cares? Really?

                      Linus
