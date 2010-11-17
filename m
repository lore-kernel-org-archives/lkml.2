Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab0KQALx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:11:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25193 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab0KQALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:11:52 -0500
Date: Tue, 16 Nov 2010 16:10:47 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/44] fs/ocfs2: Remove unnecessary semicolons
Message-ID: <20101117001046.GE10237@mail.oracle.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <cover.1289789604.git.joe@perches.com>
 <e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 07:04:55PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Joel Becker <joel.becker@oracle.com>


> ---
>  fs/ocfs2/refcounttree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index b5f9160..da14a42 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3704,7 +3704,7 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
>  	context->cow_start = cow_start;
>  	context->cow_len = cow_len;
>  	context->ref_tree = ref_tree;
> -	context->ref_root_bh = ref_root_bh;;
> +	context->ref_root_bh = ref_root_bh;
>  	context->cow_object = xv;
>  
>  	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
> -- 
> 1.7.3.1.g432b3.dirty
> 

-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
