Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2LTGVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:21:49 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:49242 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2LTGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:21:43 -0500
Subject: Re: resend--[PATCH]  improve read ahead in kernel
From: Simon Jeons <simon.jeons@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: xtu4 <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, linux-mm@kvack.org,
        di.zhang@intel.com
In-Reply-To: <20121216021508.GA3629@dcvr.yhbt.net>
References: <50C4B4E7.60601@intel.com> <50C6AB45.606@intel.com>
	 <20121216021508.GA3629@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Dec 2012 01:20:35 -0500
Message-ID: <1355984435.1374.3.camel@kernel-VirtualBox>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-16 at 02:15 +0000, Eric Wong wrote:
> xtu4 <xiaobing.tu@intel.com> wrote:
> > resend it, due to format error
> > 
> > Subject: [PATCH] when system in low memory scenario, imaging there is a mp3
> >  play, ora video play, we need to read mp3 or video file
> >  from memory to page cache,but when system lack of memory,
> >  page cache of mp3 or video file will be reclaimed.once read
> >  in memory, then reclaimed, it will cause audio or video
> >  glitch,and it will increase the io operation at the same
> >  time.
> 
> To me, this basically describes how POSIX_FADV_NOREUSE should work.

Hi Eric,

But why fadvise POSIX_FADV_NOREUSE almost do nothing? Why not set some
flag or other things for these use once data?

> I would like to have this ability via fadvise (and not CONFIG_).
> 
> Also, I think your patch has too many #ifdefs to be accepted.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


