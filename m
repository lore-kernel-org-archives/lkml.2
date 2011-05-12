Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab1ELOZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:25:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50044 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1ELOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pZY+Vu0csxNNKQiuPahVjFOpdOp4WUcAp5rvMEWVZO/hzx6gC6K0+nzt6Qfv7hQ9fy
         RHnUhF8HyG+KoB4nNtCMpD74LWmkBF7qUnbA4A4D4Ekt/KccQstR9HlIQDSLicXX6pph
         40emWE9G/p/V8ivF3CiEfKq9X7UQ/r2ZiGYRY=
MIME-Version: 1.0
In-Reply-To: <20110512140032.289087832@intel.com>
References: <20110512135706.937596128@intel.com>
	<20110512140032.289087832@intel.com>
Date: Thu, 12 May 2011 23:25:16 +0900
Message-ID: <BANLkTikhF+TDxMWmy5Z3y=MUjJg422wdzg@mail.gmail.com>
Subject: Re: [PATCH 13/17] writeback: remove writeback_control.more_io
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:57 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> When wbc.more_io was first introduced, it indicates whether there are
> at least one superblock whose s_more_io contains more IO work. Now with
> the per-bdi writeback, it can be replaced with a simple b_more_io test.
>
> Acked-by: Jan Kara <jack@suse.cz>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> CC: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
