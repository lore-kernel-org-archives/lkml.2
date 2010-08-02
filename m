Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0HBMvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:51:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:34953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0HBMvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:51:38 -0400
Date: Mon, 2 Aug 2010 14:51:11 +0200
From: Jan Kara <jack@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: jack@suse.cz, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]udf:super.c Fix warning: variable 'sbi' set but not used
Message-ID: <20100802125110.GD3278@quack.suse.cz>
References: <1278564133-19682-1-git-send-email-justinmattock@gmail.com>
 <4C547367.6070208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C547367.6070208@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 31-07-10 12:03:03, Justin P. Mattock wrote:
> any ideas on the status of this?
  I have it in my tree and will push it to Linus in this merge window.

								Honza
> 
> >This fixes this warning when building the kernel:
> >   CC      fs/udf/super.o
> >fs/udf/super.c: In function 'udf_load_sequence':
> >fs/udf/super.c:1582:22: warning: variable 'sbi' set but not used
> >Please have a look, when you have time and let me know.
> >
> >Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >
> >---
> >  fs/udf/super.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> >diff --git a/fs/udf/super.c b/fs/udf/super.c
> >index 612d1e2..12bb651 100644
> >--- a/fs/udf/super.c
> >+++ b/fs/udf/super.c
> >@@ -1579,9 +1579,7 @@ static int udf_load_sequence(struct super_block *sb, struct buffer_head *bh,
> >  {
> >  	struct anchorVolDescPtr *anchor;
> >  	long main_s, main_e, reserve_s, reserve_e;
> >-	struct udf_sb_info *sbi;
> >
> >-	sbi = UDF_SB(sb);
> >  	anchor = (struct anchorVolDescPtr *)bh->b_data;
> >
> >  	/* Locate the main sequence */
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
