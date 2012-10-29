Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428Ab2J2Sfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:35:40 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:32829 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378Ab2J2Sfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <508EC926.3040906@kernel.dk>
References: <508EC926.3040906@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Oct 2012 11:35:16 -0700
X-Google-Sender-Auth: DJVGmZywjqv8Z4ftWylIaNxpNNw
Message-ID: <CA+55aFwLUuwue0RQn2r1EZgZL_r-wO-cjJAgpUObXKMkA7S1xQ@mail.gmail.com>
Subject: Re: [GIT PULL] block driver bits for 3.7
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Later than I would have liked, but I was traveling around the merge
> window and then a fixes snuck in past that and I wanted to ensure that
> everything was fully baked again.

Didn't we agree last time that drbd just wasn't important enough to
*constantly* cause these kinds of "lots of late fixes"?

In fact, they aren't even fixes. There's a single small commit during
the merge window since v3.6 touching that driver, and it wasn't even
drbd-specific.

In other words, I see absolutely no reason to pull this stuff at this
time. It's so far out of the merge window that it's not funny, and it
has absolutely nothing about it that says "fixes".

So mind sending just the actual *fixes* for actual regressions, and
then you can re-push this for the next merge window?

          Linus
