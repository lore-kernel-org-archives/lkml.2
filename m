Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2J2TNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:13:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2J2TNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:13:37 -0400
Message-ID: <508ED55E.4000308@kernel.dk>
Date: Mon, 29 Oct 2012 20:13:34 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block driver bits for 3.7
References: <508EC926.3040906@kernel.dk> <CA+55aFwLUuwue0RQn2r1EZgZL_r-wO-cjJAgpUObXKMkA7S1xQ@mail.gmail.com>
In-Reply-To: <CA+55aFwLUuwue0RQn2r1EZgZL_r-wO-cjJAgpUObXKMkA7S1xQ@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-29 19:35, Linus Torvalds wrote:
> On Mon, Oct 29, 2012 at 11:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Later than I would have liked, but I was traveling around the merge
>> window and then a fixes snuck in past that and I wanted to ensure that
>> everything was fully baked again.
> 
> Didn't we agree last time that drbd just wasn't important enough to
> *constantly* cause these kinds of "lots of late fixes"?
> 
> In fact, they aren't even fixes. There's a single small commit during
> the merge window since v3.6 touching that driver, and it wasn't even
> drbd-specific.
> 
> In other words, I see absolutely no reason to pull this stuff at this
> time. It's so far out of the merge window that it's not funny, and it
> has absolutely nothing about it that says "fixes".
> 
> So mind sending just the actual *fixes* for actual regressions, and
> then you can re-push this for the next merge window?

It was actually the floppy part that caused a delay on my end. But sure,
I can distill this down given the time. I'll send out a new one
tomorrow.

-- 
Jens Axboe

