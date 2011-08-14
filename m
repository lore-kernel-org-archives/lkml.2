Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab1HNXi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:38:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1HNXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Aug 2011 16:38:35 -0700
Message-ID: <CA+55aFznFY-j4cE29_JDgPNQixuFFNJn+pgo2WxBR1LXK=OkfQ@mail.gmail.com>
Subject: Re: Linux 3.1-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 3:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, I would be happy if it calmed down further. 300+ commits
> for -rc2 is good, but please make me even happier for -rc3 by ONLY
> sending me real fixes. Think of it as "fairly late in the -rc series",
> because I really want to compensate for the merge window being fairly
> chaotic.

.. oh, and a couple of things I forgot to mention.

The mirroring from master.kernel.org to the public sites has been
pretty slow lately, and the main machine has been under a constant
load of about 35-50 for the last few days doing rsync checksumming or
something.

So it may not show up on the public sites for a while. I'm still not
seeing the stuff I pushed out early in the morning on git.kernel.org,
for example. So right now the delay seems to be in the 12+ hour range.

Developers who have direct access to master.kernel.org can obviously
see it, but...

The other thing I forgot to mention was that people are now actively
encouraged to test out SLUB debugging again. Not only is it always
nice to enable allocator debugging to find bugs elsewhere, but this
time it's doubly encouraged just to double- and triple-check that the
SLUB bugs that caused problems are gone. In addition to whatever bugs
elsewhere caught by redzoning and poisoning.

                Linus
