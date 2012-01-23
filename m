Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2AWUdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:33:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46171 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2AWUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:33:17 -0500
Date: Mon, 23 Jan 2012 12:33:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123203312.GL12652@google.com>
References: <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
 <20120123184336.GI12652@google.com>
 <20120123193335.GK12652@google.com>
 <20120123195717.GM25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123195717.GM25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 02:57:17PM -0500, Vivek Goyal wrote:
> It would be good if you add one more part to your series (say part4) to
> make it happen. We probably don't want to get into mess that from kernel
> version A to B we had x behavior, from B to C we broke changed it to y
> and in kernel version D we restored it back to x. User space now go
> figure what kernel version you are running and behave appropriately. For
> distributions supporting these different kernels will become a mess.
> 
> So IMHO, if you can keep pol-specific clearing part a separate series
> which gets committed in the same kernel version, would help a lot.

Sure, we're at the beginning of this devel window.  I'm fairly sure
we'll have enough time to sort it out before the next merge window.

-- 
tejun
