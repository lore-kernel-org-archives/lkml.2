Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1BXTvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:51:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57596 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab1BXTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=AhISD6n/uxeJHsqCdo1NGKC3HgavB6W7y1ujRmFE6kIwYCRrwiGpK1b7Ph6/CZNrE8
         szSFe7TmAwrIXu6/7u0SFlpqUtmhTfhY4B25mRPQRzYIcVL52e0FLi2vnpvdy9nzPYEo
         qU1Rj6hgyMEdQO0yf+mAH/MSTpIBBUv0lKVLE=
MIME-Version: 1.0
Date: Thu, 24 Feb 2011 19:50:58 +0000
Message-ID: <AANLkTinKAMztaH+xXeT0ZHorsgHAwMA1ee4M_ybXKWP0@mail.gmail.com>
Subject: Re: PING? cleancache for 2.6.39 window?
From: Matt <jackdachef@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hi Andrew (and Linus) --

>As you may have seen, gregkh has taken zcache into drivers/staging
>for merging when the 2.6.39 window opens.  And zcache (which
>works entirely in-kernel, no virtualization required) depends on
>cleancache.

>Cleancache and zcache are both in linux-next and, via linux-next,
>in mmotm.  Last October, Linus said that he preferred cleancache
>to merge via you (Andrew), not pulled from my git tree.  So:

>1) Is cleancache finally now acceptable for merging in the
>   upcoming 2.6.39 window? and
>2) If so, is there anything else I need to do to ensure the
>   merging of cleancache happens during the open window or will
>   it all happen automagically (from my point of view) through
>   your (Andrew's) normal open-window processes?

>Sorry to be excessively persistent, but I don't want to miss
>the 2.6.39 window due to my newbie-ness.  And I plan to be on
>vacation for some time during March and would also like to ensure
>I don't miss something *I* need to do before or during the
>window.

>Thanks,
>Dan Magenheimer

Hi Linus, Hi Andrew,

Hi Dan,

will this get into 2.6.39 ?

It's been running  fine for me now with 2.6.37 for some time and I
have to say that it definitely cuts latencies & time needed to work

under higher memory or cpu pressure workloads (e.g. rsyncing while
compiling big programs such as libreoffice or chromium and listening
to audio at the same time) with the added bonus of less swapping and
memory consumption of the filesystem pagecache.

I haven't seen any problems so far with ext4,

btrfs very probably also will work fine in the near future (the umount
problem with btrfs I've noticed & reported is currently under
investigation & a fix on the way).

So there's no data-eating or other real problem right now that might
seriously hinder further widespread testing ;)

Getting this into mainline staging and the willingness of filesystem
developers provided - there could also be the possibility to add
support for XFS and other filesystems - making fast & excellent
filesystems (and workloads) even more efficient :)


I don't know if it's already under consideration or in linux-next but
the "zram_xvmalloc: 64K page fixes and optimizations" (which I'm
currently testing with zcache) might improve things even more.


Thanks for your consideration & Regards

Matt
