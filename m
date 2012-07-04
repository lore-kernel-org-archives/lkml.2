Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab2GDHbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:31:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2GDHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:31:47 -0400
Date: Wed, 4 Jul 2012 00:31:36 -0700
From: Joel Becker <jlbec@evilplan.org>
To: roel <roel.kluin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>,
        moderated for non-subscribers <ocfs2-devel@oss.oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: Misplaced parens in unlikley
Message-ID: <20120704073136.GB9863@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: roel <roel.kluin@gmail.com>,
	Mark Fasheh <mfasheh@suse.com>,
	moderated for non-subscribers <ocfs2-devel@oss.oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4EE682F3.9070905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE682F3.9070905@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:40:51PM +0100, roel wrote:
> Fix misplaced parentheses
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This patch is now (finally) part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlmglue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 81a4cd2..274529c 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -456,7 +456,7 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
>  	stats->ls_gets++;
>  	stats->ls_total += ktime_to_ns(kt);
>  	/* overflow */
> -	if (unlikely(stats->ls_gets) == 0) {
> +	if (unlikely(stats->ls_gets == 0)) {
>  		stats->ls_gets++;
>  		stats->ls_total = ktime_to_ns(kt);
>  	}

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec@evilplan.org
