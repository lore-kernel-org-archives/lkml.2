Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0CYSio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:38:44 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46934 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753674Ab0CYSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:38:42 -0400
Subject: Re: [PATCH 11/16] XFS xfs_trace.c: duplicated include
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, xfs-masters@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
	 <1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 13:37:39 -0500
Message-ID: <1269542259.2523.25.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 18:37:40.0531 (UTC) FILETIME=[3FE83830:01CACC4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 18:22 +0100, Andrea Gelmini wrote:
> fs/xfs/linux-2.6/xfs_trace.c: xfs_attr_sf.h is included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Looks good.	-Alex

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_trace.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
> index 5a10760..cb840e0 100644
> --- a/fs/xfs/linux-2.6/xfs_trace.c
> +++ b/fs/xfs/linux-2.6/xfs_trace.c
> @@ -41,7 +41,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
> -#include "xfs_attr_sf.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_buf_item.h"



