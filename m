Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2BIJfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:35:09 -0500
Received: from mailhost-c5-m0.nerim.net ([78.40.49.141]:24420 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757660Ab2BIJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:35:07 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 04:35:06 EST
Date: Thu, 9 Feb 2012 10:25:35 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120209092535.GA10272@brouette>
References: <20120208110143.GA5550@localhost>
 <1328750089.5949.1.camel@sli10-conroe>
 <20120209080726.GB28465@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209080726.GB28465@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Wu Fengguang <fengguang.wu@intel.com> [2012-02-09 16:07]:
> Done, thanks! Here is the updated patch with O_SYNC write fix.

Got these errors with the updated patch on top of 3.3-rc3:

fs/sync.c: In function 'vfs_fsync_range':
fs/sync.c:167:18: error: storage size of 'plug' isn't known
fs/sync.c:173:2: error: implicit declaration of function 'blk_start_plug' [-Werror=implicit-function-declaration]
fs/sync.c:175:2: error: implicit declaration of function 'blk_finish_plug' [-Werror=implicit-function-declaration]
fs/sync.c:167:18: warning: unused variable 'plug' [-Wunused-variable]

-- 
Damien
