Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab0FJP4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:56:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab0FJP4V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <4C10EC2A.8060002@fusionio.com>
References: <4C10EC2A.8060002@fusionio.com>
Date: Thu, 10 Jun 2010 08:55:44 -0700
Message-ID: <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 6:44 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> - A set of patches fixing the WB_SYNC_NONE writeback from Christoph. So
>  we should finally have both functional and working WB_SYNC_NONE from
>  umount context.

I _really_ think this is too late, considering how broken it has been.
We already reverted the WB_SYNC_NONE things exactly because it didn't
work, didn't we? I'm going to be off-line in two days, and this part
of the pull request really makes me nervous, if only simply because of
the history of it all (ie it's always been broken, why shouldn't it be
broken now?).

IOW, that's a lot of scary changes, that have historically not been
safe or sufficiently tested, and have caused problems for various
filesystems. Convince me why they should suddenly be ok to merge?

                     Linus
