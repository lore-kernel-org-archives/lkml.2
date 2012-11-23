Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2KWNZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:25:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:52329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2KWNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:25:29 -0500
Message-ID: <50AF7901.20401@kernel.dk>
Date: Fri, 23 Nov 2012 14:24:17 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Recent kernel "mount" slow
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com> <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com> <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com> <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
In-Reply-To: <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-22 20:21, Linus Torvalds wrote:
> Doesn't sound like a fsdevel issue since it seems to be independent of
> filesystems. More like some generic block layer thing. Adding Jens
> (and quoting the whole thing)
> 
> Jens, any ideas? Most of your stuff came in after -rc2, which would
> fit with the fact that most of the slowdown seems to be after -rc2
> according to Jeff.

No ideas. Looking at what went in from my side, only the rq plug sorting
is a core change, and that should not cause any change in behaviour for
a single device. That's commit 975927b9.

> Jeff, more bisecting would be good, though.

Probably required, yes...

-- 
Jens Axboe

