Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0FNXlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:41:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39529 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0FNXla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ez7KvtlkMJFvQDRmbO6JUrTV/W8unXEHA/yltdZIjx91EmAW2G5wuYElYqUWdHd3Ds
         4HY3IJDbHCksBjzAMY6TbobkDzY82JFQnOURR41XrZpCtcxWCkrvH0R/NnvS59Tey3BT
         el59SWW/ayhiFJbFNrObZ0/hmUO7bSgcz+qls=
Message-ID: <4C16BE39.2080303@gmail.com>
Date: Mon, 14 Jun 2010 16:41:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: reiserfs-devel@vger.kernel.org, edward.shishkin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8 v2]reiserfs:stree.c Fix variable set but not used.
References: <1276555568-31550-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276555568-31550-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 03:46 PM, Justin P. Mattock wrote:
> Resend of this patch due to previous whitespace issues.
> The below fixes this warning:
> fs/reiserfs/stree.c: In function 'search_by_key':
> fs/reiserfs/stree.c:602:6: warning: variable 'right_neighbor_of_leaf_node' set but not used
>
>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>   Acked-by: Edward Shishkin<edward.shishkin@gmail.com>
>
> ---
>   fs/reiserfs/stree.c |    3 ---
>   1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
> index 313d39d..f268067 100644
> --- a/fs/reiserfs/stree.c
> +++ b/fs/reiserfs/stree.c
> @@ -599,7 +599,6 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>   	struct buffer_head *bh;
>   	struct path_element *last_element;
>   	int node_level, retval;
> -	int right_neighbor_of_leaf_node;
>   	int fs_gen;
>   	struct buffer_head *reada_bh[SEARCH_BY_KEY_READA];
>   	b_blocknr_t reada_blocks[SEARCH_BY_KEY_READA];
> @@ -617,8 +616,6 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>
>   	pathrelse(search_path);
>
> -	right_neighbor_of_leaf_node = 0;
> -
>   	/* With each iteration of this loop we search through the items in the
>   	   current node, and calculate the next current node(next path element)
>   	   for the next iteration of this loop.. */



shit I messed up.. forgot the last bit for this.
sorry about that I'll resend.

Justin P. Mattock
