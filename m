Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1HXSQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:16:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61536 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1HXSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <4E553ABF.3030904@kernel.dk>
References: <201108241641.42676.philipp.reisner@linbit.com>
	<CAGZ=bq+A1ExZYRnuBBwfAq7Ez37mpBtT1_T91AWcchDBZ3iqPw@mail.gmail.com>
	<4E552E9C.2000104@kernel.dk>
	<201108241949.43716.philipp.reisner@linbit.com>
	<4E553ABF.3030904@kernel.dk>
Date: Wed, 24 Aug 2011 21:16:02 +0300
X-Google-Sender-Auth: O1ftiFyA1EaB7lYaQZ092x45sgw
Message-ID: <CAOJsxLHNeZq-kOy2UorOTia7AO3UmfpaWm6gfx3WeW7J6F4hEw@mail.gmail.com>
Subject: Re: [GIT PULL] drbd-8.4 for mainline
From: Pekka Enberg <penberg@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 8:54 PM, Jens Axboe <axboe@kernel.dk> wrote:
> So, please do this right. The email you sent is perfect for a 0/N header
> email, then each patch must follow as a reply to that. There's git
> send-email to help you with this. If you haven't used it before, I'd
> advise you to do a dry-run or two to your own email address to ensure
> that it produces the right result. When it does, then send it off to
> lkml and myself. Then I too will see reviews and have a better chance of
> judging whether this is mergeable now or not.

Another thing: there's roughly 500 commit in the pull request. Please
don't send all of them at the same time if you want people to take a
look at them.
