Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2A3CaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:30:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58656 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2A3CaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:30:16 -0500
Date: Sun, 29 Jan 2012 18:30:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Message-ID: <20120130023012.GH17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <20120129192447.GB17211@htj.dyndns.org>
 <4F25F5F3.6060507@gmail.com>
 <20120130014703.GG17211@htj.dyndns.org>
 <4F25FEE5.5010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F25FEE5.5010309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:22:29AM +0900, Namhyung Kim wrote:
> >It's just that this patch as it stands will break the existing tools
> >and is likely to cause some amount of head scratching for blktrace
> >users upgrading to new kernel with existing userland, so yeah, I think
> >it should be filtered in kernel from blktrace.c.
> 
> Will it break blktrace? Looking at the code, not tested though, it
> will just add one more 'C' line for bounced bio, and that's it? The
> blktrace will get way more 'C' lines for normal request based
> devices and it needs to be handled anyway. Am I missing something?

Hmmm... maybe I'm confused.  Wouldn't it cause duplicate completions
for all rq based drivers too?

-- 
tejun
