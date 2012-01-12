Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2ALH31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:29:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34100 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2ALH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <20120112065144.GA24051@linux-sh.org>
References: <20120112065144.GA24051@linux-sh.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 23:29:02 -0800
X-Google-Sender-Auth: 4_iFm5PemGz4HTsWv7oN8z4Bjbc
Message-ID: <CA+55aFzTJe_VwDxiBKyB3dNCJfm=HXxib4Y4fGihhoBFvXiOTw@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 3.3-rc1
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:51 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> Here goes my attempt at a merge request by way of signed tag, hopefully
> I've not botched anything too terribly.

Looks fine. Except your key isn't actually signed by anybody I
recognize, so it's kind of worthless that way.

(And it seems to be just a 1024 bit key, which could be improved too)

But the signing part looks technically fine.

> I noticed some people using 3.3 in their signed tags and others with a
> single for-linus one that seems like it will be overwritten on each
> subsequent merge. I've opted for the latter as presumably verification is
> only of interest at the time of merging, but can switch to the former if
> that's the preferred way going forward.

I don't think it matters. Even naming them "3.3" doesn't really make
it any more unique if there are multiple pulls, so I say "whatever
makes sense as a name". If people want to make it clear that it's the
merge pull for the 3.3 release, that's fine. And if they don't, that's
fine too.

You put the "3.3 merge window" in the signed tag itself, and that's
fine too, although that is actually an excellent place to talk about
some high-level details about what that merge brings in. Because the
tag message gets included as part of the merge message (although I can
also edit it), so if you want to talk about the highlights, that's a
great way to do it.

But if there are no real highlights, that's fine too ;)

                   Linus
