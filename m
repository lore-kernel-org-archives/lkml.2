Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1ISH2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:28:09 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:55928 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1ISH2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:28:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110910064531.GA32536@moria>
References: <20110910064531.GA32536@moria>
Date: Mon, 19 Sep 2011 10:28:03 +0300
X-Google-Sender-Auth: C8JPsZwaXo2KOLO7LcNWYc8MZjY
Message-ID: <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

On Sat, Sep 10, 2011 at 9:45 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> bcache, n.: a cache for arbitrary block devices that uses an SSD
>
> It's probably past time I started poking people to see about getting
> this stuff in. It's synced up with mainline, the documentation is for
> once relatively up to date, and it looks just about production ready.
>
> Suggestions are more than welcome on how to make it easier to review -
> it's entirely too much code, I know (near 10k lines now). I'll be
> emailing the patches that touch other parts of the kernel separately.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself
> as a new block device, a bit like say md. You can cache an arbitrary
> number of block devices with a single cache device, and attach and
> detach things at runtime - it's quite flexible.

The changelog is pretty useless for people like myself who have never
heard of bcache before because it lacks any explanation why bcache is
useful (i.e. a real-world use case).

                        Pekka
