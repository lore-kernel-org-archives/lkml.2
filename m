Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2LQRJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:09:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2LQRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:09:51 -0500
Message-ID: <50CF51DB.5020302@kernel.dk>
Date: Mon, 17 Dec 2012 18:09:47 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com> <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk> <CA+55aFwrqn3JXdym8rYE_sNzgkobNGitOyAgkxv5w18ZYGjc8g@mail.gmail.com>
In-Reply-To: <CA+55aFwrqn3JXdym8rYE_sNzgkobNGitOyAgkxv5w18ZYGjc8g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 18:08, Linus Torvalds wrote:
> On Mon, Dec 17, 2012 at 9:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Linus, how do you want to handle this? I can do a revert and re-send a
>> pull.
> 
> Well, I already did the pull. Can we just stick in a commit that hides
> the API while this gets discussed/fixes?

Sure, works for me. Then we'll either yank it for 3.8 final, or adopt.
Whatever fits the timeframe.

I'll send you a pull later.

-- 
Jens Axboe

