Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2LQRIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:08:30 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56811 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2LQRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:08:29 -0500
MIME-Version: 1.0
In-Reply-To: <50CF50AA.7080600@kernel.dk>
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
 <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Dec 2012 09:08:08 -0800
X-Google-Sender-Auth: NT2EHZcg1fIfo3qyozsAAUgWKLI
Message-ID: <CA+55aFwrqn3JXdym8rYE_sNzgkobNGitOyAgkxv5w18ZYGjc8g@mail.gmail.com>
Subject: Re: [GIT PULL] core block IO bits for 3.8
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 9:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Linus, how do you want to handle this? I can do a revert and re-send a
> pull.

Well, I already did the pull. Can we just stick in a commit that hides
the API while this gets discussed/fixes?

             Linus
