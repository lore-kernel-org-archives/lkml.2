Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0KWAn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:43:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932339Ab0KWAn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:43:58 -0500
Date: Mon, 22 Nov 2010 16:43:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] romfs: have romfs_fs.h pull in necessary headers
Message-Id: <20101122164356.ab44c4ae.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikJQ4usvm9tx1Xm+LcfFgduMVRqPyQPpkYUyjff@mail.gmail.com>
References: <1290385461-29831-1-git-send-email-vapier@gentoo.org>
	<20101122135855.6825700d.akpm@linux-foundation.org>
	<AANLkTikJQ4usvm9tx1Xm+LcfFgduMVRqPyQPpkYUyjff@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 19:40:16 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> On Mon, Nov 22, 2010 at 16:58, Andrew Morton wrote:
> > On Sun, 21 Nov 2010 19:24:21 -0500 Mike Frysinger wrote:
> >> This header uses things like __be32, so pull in linux/types.h.
> >>
> >> Further, it uses BLOCK_SIZE, so pull in linux/fs.h.
> >>
> >> --- a/include/linux/romfs_fs.h
> >> +++ b/include/linux/romfs_fs.h
> >> @@ -1,6 +1,9 @@
> >> __#ifndef __LINUX_ROMFS_FS_H
> >> __#define __LINUX_ROMFS_FS_H
> >>
> >> +#include <linux/types.h>
> >> +#include <linux/fs.h>
> >> +
> >> __/* The basic structures of the romfs filesystem */
> >>
> >> __#define ROMBSIZE BLOCK_SIZE
> >
> > Better changelogs please.
> >
> > Does this fix any build error? __If so, is that build error present in
> > 2.6.36 or earlier?
> 
> headers should include the headers that define types/things that the
> header itself needs

I take that to mean "no" and "no", hence the fix is not needed in
2.6.37 and is not needed in -stable.

Thanks for being so helpful.
