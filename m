Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1EEJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:25:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39476 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1EEJZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IqmEPPl8Yvg/v8J2DMxZz2k9mXRI5lV4WflHJv4LBV8rCuRSTX7GjlKERVG2OXKl8M
         Dews6ef4b+cyT02yMFps6oRdx/ue42yxrzFX5eL0B46p5qkra5Skb77lfgcOM/jUL47u
         kBnFJgTIAyFOyrux7VbmqXRCHZw/071599AIc=
MIME-Version: 1.0
In-Reply-To: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
References: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
Date: Thu, 5 May 2011 17:25:26 +0800
Message-ID: <BANLkTi=spGxd6nd6dSRpK+0q22zi3Pw3ww@mail.gmail.com>
Subject: Re: [PATCH 1/3] ext4: remove incorrect 'extern' keyword for function-definition
From: Yong Zhang <yong.zhang0@gmail.com>
To: Robin Dong <hao.bigrat@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 4:51 PM, Robin Dong <hao.bigrat@gmail.com> wrote:
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext4/ialloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 1ce240a..d4929ae 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1229,7 +1229,7 @@ unsigned long ext4_count_dirs(struct super_block * sb)
>  * inode allocation from the current group, so we take alloc_sem lock, to
>  * block ext4_claim_inode until we are finished.
>  */
> -extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
> +int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,

Is there any difference with your modification?

Thanks,
Yong

>                                 int barrier)
>  {
>        struct ext4_group_info *grp = ext4_get_group_info(sb, group);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
