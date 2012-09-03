Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2ICPhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:37:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab2ICPhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:37:39 -0400
Date: Mon, 3 Sep 2012 17:37:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug fixes/cleanups for floppy driver (v4)
In-Reply-To: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
Message-ID: <alpine.LNX.2.00.1209031735310.20709@pobox.suse.cz>
References: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Herton Ronaldo Krzesinski wrote:

> Following this are fixes for bugs noticed on floppy driver, and some
> extra cleanups. Version history below:
> 
> v2: separate fixes, and incorporate suggestions by Vivek Goyal.
>     also I splitted the cleanups from fixes.
> v3: remove dr, also this possibly makes error handling more readable
>     (suggested by by Vivek Goyal), incorporate acks.
> v4: re-shuffle series with patch from Ben Hutchings handling the queue
>     reference in a better way inside genhd
> 
> Patches 1-2 and 4 are general bug fixes for problems noted in the floppy
> driver initialization and its error handling. They are the minimal fix
> required, so it's suitable and easy to pick for stable releases (so
> are Cc'd to stable), and thus not contain cleanups or re-factoring.
> 
> Patch 3 is a patch from Ben Hutchings fixing in a better way the extra
> queue reference issue that was introduced in commit 523e1d3 ('block:
> make gendisk hold a reference to its queue'). Instead of making the
> drivers worry about the extra reference, fix it and handle that in a
> better way inside genhd. I'm not sure if this should go with the floppy
> changes or picked up separate for the block tree. In any case, patch 6
> will only apply after it is applied. His patch was proposed with the
> previous series I submitted and handles the problem better so I took the
> liberty to include now, I just fixed the changelog as was noticed that
> time to reference the right commit, and included my ack.
> 
> Patch 5 and 6 implements earlier suggested cleanups and enhancements.

I have now finally got to reviewing the series and all the previous 
Vivek's and Ben's comments and verifying this on real HW, sorry for the 
delay.

Applied, thanks Herton.

-- 
Jiri Kosina
SUSE Labs
