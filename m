Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0DYSm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 14:42:57 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51379 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752833Ab0DYSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 14:42:56 -0400
Date: Sun, 25 Apr 2010 13:48:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
Message-ID: <20100425114825.GA1865@ucw.cz>
References: <20100423194107.GA20322@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423194107.GA20322@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- /dev/null
> +++ b/block/bcache.c
> @@ -0,0 +1,2337 @@
> +#define pr_fmt(fmt) "bcache: %s() " fmt, __func__
> +
> +#include <linux/blkdev.h>
> +#include <linux/buffer_head.h>

Some copyright, gpl and short note what it is would be nice.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
