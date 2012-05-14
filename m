Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2ENQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:25:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63982 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2ENQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:25:27 -0400
Date: Mon, 14 May 2012 09:25:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
Message-ID: <20120514162521.GA2366@google.com>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 13, 2012 at 11:02:07AM +0200, Jiri Kosina wrote:
> Block layer now handles O_EXCL in a generic way for block devices.
> 
> The semantics is however different for floppy and all other block devices,
> as floppy driver contains its own O_EXCL handling.
> 
> The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL 
> open of this file", while for floppy bdev the semantics is "if someone has 
> the bdev open with O_EXCL, noone else can open it".
> 
> Remove the floppy-specific handling and let the generic bdev code O_EXCL
> handling take over.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Patch looks good to me but why do we want to change this at this
point?

Thanks.

-- 
tejun
