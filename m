Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2LQTjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:39:07 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46552 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2LQTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <50CF7249.3030504@kernel.dk>
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
 <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk>
 <x49ehiowqga.fsf@segfault.boston.devel.redhat.com> <50CF6D35.5040300@kernel.dk>
 <CA+55aFxoN+4Nu1YB=b+3eTWKq=_h_cN5i2DVzeYCEqNyN_PwZA@mail.gmail.com> <50CF7249.3030504@kernel.dk>
From: Shentino <shentino@gmail.com>
Date: Mon, 17 Dec 2012 11:38:23 -0800
Message-ID: <CAGDaZ_p=n5gYDwxXMFPagXBnG51Th1h5X97hd2cDdWKuC1F9yw@mail.gmail.com>
Subject: Re: [GIT PULL] core block IO bits for 3.8
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-12-17 20:27, Linus Torvalds wrote:
>> On Mon, Dec 17, 2012 at 11:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Sigh, in that case, yes lets just revert it.
>>
>> So just to check - we're talking about commit 8fa72d234da9 ("bdi: add
>> a user-tunable cpu_list for the bdi flusher threads"). It reverts
>> cleanly, but I wanted to make sure we're all on the same page..

Page, heh.

> That is the one, revert at will :-)
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
