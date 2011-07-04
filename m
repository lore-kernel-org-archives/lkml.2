Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1GDAnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 20:43:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52145 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1GDAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 20:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <1309721963-5577-1-git-send-email-dmitry.fink@palm.com>
References: <1309721963-5577-1-git-send-email-dmitry.fink@palm.com>
Date: Mon, 4 Jul 2011 09:43:09 +0900
Message-ID: <CAEwNFnAYAWy4tabCuzGUwXjLpZVbxhKMmPXnhmCuH5pckOXBRw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap: Don't count shmem pages as free in __vm_enough_memory
From: Minchan Kim <minchan.kim@gmail.com>
To: Dmitry Fink <finikk@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dmitry Fink <dmitry.fink@palm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 4:39 AM, Dmitry Fink <finikk@gmail.com> wrote:
> shmem pages can't be reclaimed and if they are swapped out
> that doesn't affect the overall available memory in the system,
> so don't count them along with the rest of the file backed pages.
>
> Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I am not sure the description is good. :(
But I think this patch is reasonable.

In swapless system,guessing overcommit can have a problem.
And in current implementation of OVERCOMMIT_GUESS, we consider anon
pages as empty space of swap so shmem pages should be accounted by
that.

-- 
Kind regards,
Minchan Kim
