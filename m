Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab1EZTJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:09:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51386 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1EZTJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:09:08 -0400
Message-ID: <4DDEA553.5030108@kernel.dk>
Date: Thu, 26 May 2011 21:09:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] brd: partition handling fixes
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-26 14:55, Namhyung Kim wrote:
> Hello.
> 
> This is a patch set for fixing bugs on partition handling code which
> was found when I read loop block device code as well as some cleanups.
> 
> The patch 2/5 and 3/5 are real fixes and should go to the stable tree
> as Jens suggested on loop patches. Since partition managing code was
> introduced by commit d7853d1f8932 ("brd: modify ramdisk device to be
> able to manage partitions") all stable releases would need these fixes.
> 
>   $ git name-rev --tags d7853d1f8932
>   d7853d1f8932 tags/v2.6.26-rc1~122

Looks good, applied all 5. Thanks!

-- 
Jens Axboe

