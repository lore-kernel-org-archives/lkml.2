Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316Ab2AFLCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:02:51 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49163 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030196Ab2AFLCu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:02:50 -0500
MIME-Version: 1.0
In-Reply-To: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
Date: Fri, 6 Jan 2012 16:32:48 +0530
Message-ID: <CADDb1s3fBFEXY5Z=ZjJtzOM09fdH4n_Je2eGAgkgqGF9n__oFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>,
        xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Courtesy: Dave Chinner


Thanks & Regards,
Amit Sahrawat

On Fri, Jan 6, 2012 at 4:42 PM, Amit Sahrawat <amit.sahrawat83@gmail.com> wrote:
> Removing the macro, as this is no more needed in the code.
> Tried to find the reference when it was last used - but the usage
> for this seemed to have been dropped long time ago.
>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/xfs/xfs_sb.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index cb6ae71..f429d9d 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -529,7 +529,6 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
>  #define        XFS_BB_TO_FSB(mp,bb)    \
>        (((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
>  #define        XFS_BB_TO_FSBT(mp,bb)   ((bb) >> (mp)->m_blkbb_log)
> -#define        XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
>
>  /*
>  * File system block to byte conversions.
> --
> 1.7.2.3
>
