Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0L0PgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:36:20 -0500
Received: from verein.lst.de ([213.95.11.210]:34177 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab0L0PgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:36:17 -0500
Date: Mon, 27 Dec 2010 16:36:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] compat: copy missing fields in compat_statfs64 to user
Message-ID: <20101227153615.GB22676@lst.de>
References: <1293381714-5264-1-git-send-email-namhyung@gmail.com> <1293381714-5264-3-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293381714-5264-3-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 01:41:54AM +0900, Namhyung Kim wrote:
> f_flags and f_spare fields were not copied to userspace when
> compat_sys_[f]statfs64 called.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
> It seems struct compat_statfs lacks the f_flags field in it but I'm not
> sure whether it is intended or not. Is it useful if I make a patch for
> it too?

Looks good.  We discussed this a while back before it fell under the
table again.

Reviewed-by: Christoph Hellwig <hch@lst.de>
